# N2H4 
## 네이버 뉴스 크롤링을 위한 도구
#### MIT 라이선스로 자유롭게 사용하셔도 좋으나 star는 제작자를 춤추게 합니다.
#### 사용하실 때 출처(링크 표기 가능)를 밝혀주시면 감사하겠습니다.
######문의는 [mrchypark@gmail.com](mailto:mrchypark@gmail.com)로 주시거나 이슈로 남겨주세요.
######[이슈](https://github.com/mrchypark/N2H4/issues)로 남겨주시면 같은 문제를 겪는 분이 해결하는데 도움이 됩니다.
```
if (!require("devtools")) install.packages("devtools")
devtools::install_github("mrchypark/N2H4")
library(N2H4)
```

## v.021

자잘한 버그들을 해결했습니다. 데모들을 3개로 나누고, 사용방법을 추가했습니다.
리눅스에서의 인코딩 문제를 해결했습니다.(사실 그냥 우회했습니다. 생각해보니 얼마나 자주 바꿀까 싶기도 하고...)
맥은 테스트가 들어오는 대로 공지하겠습니다.

```
# 실행할 수 있는 데모 리스트를 확인합니다.
demo(package="N2H4")

# example_category
# example_query
# example_comment

# 데모를 실행합니다.
demo(example_comment,package="N2H4")
```

getComment 기능을 통해 얻는 데이터를 다루기 쉽게 세분화할 계획입니다.
댓글기능 세분화는 네이버가 구조변경을 하면 바뀌어야 하므로 우선 순위가 매우 낮습니다.

## v.02

네이버 뉴스에서 댓글을 가져오는 기능을 추가했습니다.<br>
네이버에서 직접 주는 json 형태로 저장되고 생각보다 복잡하고 많은 데이터가 넘어와서 아직 정리하지 않았습니다. 사람들이 필요한 부분이 다를 것이라 생각해 그대로 두었습니다.<br>
getComment(url) 의 형태로 작성했으며 pageSize, page, sort를 설정할 수 있습니다.<br>
sort는 총 4가지로 "favorite","reply","old","new" 가 있으며<br>
favorite 호감순, reply 답글순, old 과거순, new 최신순 입니다.<br>

댓글 정보인 성별 비율, 연령대 비율 등 데이터도 확인 할 수 있어 유용해 보입니다.<br>
쓸모 없는 데이터도 많아서 한번 정리해서 옵션화 해보겠습니다.<br>
getComment(url)$result$commentList[[1]] 하시면 익숙한 data.frame 형태로 댓글 데이터를 보실 수 있습니다.


## v.01

MIT License.<br>
Check code demo/example.R<br>
Please [let me know](mailto:mrchypark@gmail.com) use this package.
