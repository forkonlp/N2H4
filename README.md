# N2H4

```
if (!require("pacman")) install.packages("pacman")
pacman::p_load_gh("mrchypark/N2H4")
```

v.02

댓글을 가져오는 기능을 추가했습니다.
네이버에서 직접 주는 json 형태로 저장되고 생각보다 복잡하고 많은 데이터가 넘어와서 아직 정리하지 않았습니다. 사람들이 필요한 부분이 다를 것이라 생각해 그대로 두었습니다.
getComment(url) 의 형태로 작성했으며 pageSize, page, sort를 설정할 수 있습니다.
sort는 총 4가지로 "favorite","reply","old","new" 가 있으며
favorite 호감순, reply 답글순, old 과거순, new 최신순 입니다.

댓글 정보인 성별 비율, 연령대 비율 등 데이터도 확인 할 수 있어 유용해 보입니다.
쓸모 없는 데이터도 많아서 한번 정리해서 옵션화 해보겠습니다.

v.01

Check code demo/example.R<br>
Please [let me know](mailto:mrchypark@gmail.com) use this code for education.
