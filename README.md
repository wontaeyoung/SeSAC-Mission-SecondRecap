# 진행 중
- SwiftUI로 UI 프레임워크 전환
- Combine으로 비동기 프레임워크 전환
- Alamofire -> URLSession으로 네트워크 라이브러리 전환

<br><br>

## 에러 케이스 파악의 어려움

이미 Utility에 구현해놓은 AFManager나 HTTP Client를 사용했다.

에러 메세지 로깅과 사용자 Alert 문구를 일괄적으로 관리하기 위해 AppError 프로토콜을 채택한 에러 케이스들을 정의하고, 네트워크 요청의 각 에러 상황에 대해 미리 정의한 AppError 케이스들을 throw 하도록 구현했다.

그래서 모든 API 콜에서 발생할 수 있는 공통적인 상황 (URL 문제, Json 디코딩, 상태코드 200번대 X)은 확인할 수 있었지만, API마다 커스텀하게 발생하는 에러에 대해 확인이 불가했다.

특히 이번 Coin API에서는 Call 횟수가 극단적으로 제한되어 있었는데, 미리 정의된 Error 케이스에 해당하지 않으니 공통적인 에러 메세지로 빠지게 되어서, 에러가 발생했을 때 Call수 제한인건지 다른 에러가 발생한건지 확인이 어려웠다.

처음에는 Alamofire를 사용하고 있었는데, 우선은 로직을 커스텀하게 구현하기 위해서 URLSession을 사용하는 HTTP Client로 교체하고, callRequest 메서드에서 추가적으로 정의한 HTTP Status Code를 받아서 에러 메세지로 확인할 수 있는 구조로 변경했다.

AppError 프로토콜로 에러를 관리하면서 일관적인 형태로 에러를 핸들링할 수 있는 장점은 있었지만, API에서 던져주는 에러를 확인할 수 있는 구조로 개선이 필요할 것 같다.

<br><br>

## 쿼리 파라미터에 true / false 전달할 때 유의할 점

쿼리 파라미터 value에 `true`라고 전달하면 1로 변환되어서 전달된다.

Int는 문자열이나 정수형이나 URL 상에서 동일하게 표현되지만, API에서 요구하는 쿼리 파라미터가 true와 같은 Bool 타입이라면 반드시 "true"로 작성해야한다.

<br><br>

## deinit과 약한 참조로 인한 메모리 시점 문제

`ChartCoordinator`는 차트 화면을 표시하기 때문에 모든 탭바 Coordinator에서 하위 Coordinator로 연결될 수 있다.

`push`된 차트 화면은 뒤로가기 버튼으로 `pop`될 때 `ChartCoordinator`가 자동으로 해제되지 않기 때문에 상위 Coordinator에 end 이벤트를 전달해서 childCoordinator 리스트에서 해제되도록 해야한다.

그래서 `ChartViewController`의 deinit 스코프에서 ViewModel에 `viewDeinitEvent`를 전달하도록 했다.

ViewModel은 viewDeinitEvent를 구독하고, Coordinator의 end 메서드를 호출한다.

처음에 이 로직이 정상적으로 수행되지 않았는데, `viewDeinitEvent`의 `subscribe` 로직에서 ViewModel을 캡처리스트에서 `weak self`로 캡처했기 때문이었다.

ViewController가 메모리에서 해제되면서 ViewModel의 RC가 0으로 내려가게 되었기 때문이었다.

그래서 `viewDeinitEvent`의 `subscribe` 로직이 수행될 때는 이미 ViewModel이 메모리에서 내려가서 로직이 수행되지 않았던 것이다.

`subscribe` 스코프에서 ViewModel을 강한 참조로 변경해서 문제가 해결되었다.

Ps. 다 작성하고나니 생각난건데 그냥 ViewModel의 deinit에서 coordinator를 해제했으면 더 쉽게 해결될 수 있었다.

<br><br>

## 커스텀 Cell Init과 Dequeue 문제

```swift
(O)
override init(frame: CGRect) {
  super.init(frame: frame)
  
  setHierarchy()
  setConstraint()
}
  
(X)
init() {
  super.init(frame: .zero)
  
  setHierarchy()
  setConstraint()
}
```

Resue 방식으로 사용하는 Cell, Collection ReusableView와 같은 클래스들은 커스텀할 때 init(frame:), init(coder:) 메서드로 구현해야한다.

일반적인 커스텀 View 클래스를 구현할때처럼 init 구문을 만들고 내부에서 super.init을 호출하려고 해도 dequeue 과정에서 호출되지 않기 때문에 크래시 에러가 발생한다.
