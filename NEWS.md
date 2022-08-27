# N2H4 0.7.1

* urltools 패키지 의존성을 제거하였습니다.
* getLike() 함수를 제거하였습니다. 추후 대응하는 다른 함수를 추가할 수 있습니다.
* Remove urltools package on deps.
* Remove getLike() functoin not work.

# N2H4 0.7.0

* getCommentHistory() 함수를 추가했습니다. 댓글 사용자의 다른 댓글을 수집하는 기능입니다.
* Add getCommentHistory() and getAllCommentHistory() function.

# N2H4 0.6.5

* CRAN 등록을 위해 DESCRIPTION 파일을 최신화하였습니다.
* Update date on DESCRIPTION for cran.

# N2H4 0.6.4

* getCommnet() 함수 동작을 수정했습니다.
* url 주소의 검증을 추가했습니다.
* Fix getComment() function not work.
* Add url validate on getComment().

# N2H4 0.6.3

# N2H4 0.6.2

* 뉴스 페이지 구조와 주소가 변경되어 동작하지 않는 문제를 수정하였습니다.
* Fixed the problem that the news page structure and address were changed and did not work.

# N2H4 0.6.1

* 인터넷 연결이 안되는 환경에서의 테스트를 위해 httptest로 테스트합니다.
* Change test using httptest with no wire.

# N2H4 0.6.0

* getMainCategory() 함수가 동작하지 않는 것을 수정했습니다.
* getVidioUrl(), getUrlListByQuery(), getQueryUrl(), getNewsTrend() 함수를 제거했습니다.
* getUrlListByCategory() 함수를 getUrlList()로 이름을 바꾸었습니다.
* 사용하지 않는 의존성 패키지를 제거하였습니다.
* Fix getMainCategory() function don't work.
* Remove functions getVidioUrl(), getUrlListByQuery(), getQueryUrl(), getNewsTrend().
* Rename function getUrlListByCategory() to getUrlList().
* Remove un-use package dependency.

# N2H4 0.5.9

* http to https

# N2H4 0.5.8

* getMainCategory() 함수에서 변경된 주소를 반영하였습니다.
* Fix getMainCategory() Function with change address.

# N2H4 0.5.7

* doctest 오류를 수정했습니다.
* hotfix for doctest.

# N2H4 0.5.6

* getMaxPageNum() 함수에서 인코딩 에러 나는 것을 수정했습니다.
* Fix getMaxPageNum() encoding error

# N2H4 0.5.4

# N2H4 0.5.3

* 패키지 버전 양식을 맞추었습니다.
* fix version schema.

# N2H4 0.5.2

* 뉴스의 날짜시간 형식을 맞추었습니다.
* fix datetime parse format.

# N2H4 0.5.1

* https 로 시작하는 주소를 사용합니다.
* fix accept https schema.

# N2H4 0.5.0

* `getQueryUrl()` 함수를 고치면서 변수를 조절하였습니다.
* fix and chanage params `getQueryUrl()` function.

# N2H4 0.4.8.4

* `getComment()`가 댓글이 없을 때 빈 `data.frame()`을 반환합니다.
* `getComment()` returns an empty `data.frame()` when there is no comment.

# N2H4 0.4.8.3

* `getComment()`의 sports news를 수집할 때 url이 `https`로 시작해도 동작합니다.
* When collecting sports news using `getComment()` function, it works even if url starts with `https`.

# N2H4 0.4.8.2

* `getComment()`의 `snsList` 컬럼을 제거하였습니다.
* Removed the `snsList` column from the result of the `getComment()` function.


# N2H4 0.4.8.1

* `getContent()`의 예외 기능의 오류를 수정하였습니다.
* fix `getContent()` functions error in bypass.

# N2H4 0.4.8

* 많은 패키지 의존성을 제거하였습니다.
* `getMaxPageNum()` 함수가 더 이상 search 옵션을 지원하지 않습니다.
* `getContent()` 함수의 retry 기능을 `httr::RETRY()` 함수로 변경하였습니다.
* Removed many package dependencies.
* `getMaxPageNum()` function no longer supports the search option.
* We changed the retry function of `getContent()` to `httr::RETRY()`.

# N2H4 0.4.7.1

* `News.md` 파일을 추가하였습니다.
* Added a `NEWS.md` file to track changes to the package.

# N2H4 0.4.7

* `getComment()`에 `type`을 추가하여 `df`와 `list`중에 선택할 수 있습니다. 기본 값은 `df`이며 `df`는 댓글 데이터만 돌려줍니다. 네이버는 댓글에 대한 풍부한 정보를 제공하며 `list`로 선택해야 모두 가져올 수 있습니다.
* You can choose between `df` and `list` by adding `type` to `getComment()`. The default value is `df`, and `df` returns only comment data. Naver provides a wealth of information about the comments and can be picked up as `list`.

# N2H4 0.4.6
getContent에 timeout 시 재시도 기능을 추가했습니다. 3번이 기본이고 rnorm(1)으로 sleep 합니다. sleep 시간을 없애고 싶으시면 0으로 설정하시면 됩니다. docker 파일을 추가하고 https://hub.docker.com/r/mrchypark/n2h4/ 에 도커 이미지를 호스팅하고 있습니다. rocker/tidyverse 가 업데이트되거나 패키지가 업데이트되면 항상 최신 빌드가 되게 되어 있으니 docker를 사용하시는 분들은 추가 세팅 없이 사용하실 수 있습니다. 아래 명령으로 실행됩니다.

```
docker -d -p 8787:8787 --name rbot mrchypark/n2h4
```

# N2H4 0.4.5
아래 언급한 내용으로 수정했습니다.

# N2H4 0.4.4
getContent 함수를 리펙토링했습니다. 각각 가져오려는 내용(title, press body 등)으로 함수를 나누고 그 함수는 tag class나 id를 입력할 수 있는 형태로 수정했습니다. 각 함수에 옵션 이름을 달리해야 getContent에서 수정할 수 있겠네요.

# N2H4 0.4.3
getQueryUrl 함수를 추가했습니다. 검색어를 입력하면 네이버에서 뉴스를 검색할 때 나오는 페이지의 url을 조합해서 결과로 줍니다. 여러 설정이 있지만 검색어와 페이지 넘버를 자주 사용하실 것 같습니다. (사실 다른 설정은 뭔지 잘 모르...) detail을 1로 하면 제목만 검색 결과로 나오고 0으로 하면 본문 일부도 함께 나옵니다. 1을 기본으로 해뒀습니다. getQueryUrl를 만들면서 getNewsTrend 함수를 추가했습니다. 예시 코드는 [여기](https://github.com/forkonlp/N2H4/wiki/%EB%89%B4%EC%8A%A4-%EC%83%9D%EC%82%B0%EB%9F%89-(trend)-%ED%91%9C-%EA%B7%B8%EB%A6%AC%EA%B8%B0-%EC%98%88%EC%8B%9C)를 참고해주세요.

# N2H4 0.4.2
setUrls, searchNews, html2text, getAllComment, getVideoUrl 함수를 추가했습니다. 
제안 및 코드 기여해주신 두분께 다시 한번 감사드립니다. 
동작함만 확인하고 추가하였기 때문에 문제가 있을 수 있습니다. 
setUrls는 본래 제안자의 의도와 다르게 결과물이 list가 아닌 data.frame으로 나오도록 수정하였습니다. 
의견이 있으면 옵션으로 넣는 방향으로 진행하겠습니다.

# N2H4 0.4.1
버전 네이밍 규칙을 다시 변경하였습니다. 
getContent나 getUrlListbyCategory 에서 필요한 부분만 가져올 수 있습니다.

# N2H4 0.0.4
버전 네이밍 규칙을 변경하였습니다. 함수를 단순화하였습니다. [위키](https://github.com/forkonlp/N2H4/wiki/%EA%B8%B0%EB%8A%A5-%EC%84%A4%EB%AA%85)를 참고해 주세요. [코드예시](https://github.com/forkonlp/N2H4/wiki/%EC%82%AC%EC%9A%A9-%EC%98%88%EC%8B%9C)도 참고하시면 좋습니다.

# N2H4 0.3
getContentParallel 기능을 추가하였습니다. 
기능에 대한 데모도 추가하였습니다. 
조금 더 빠르게 수집 가능합니다. 
이 정도 속도로 네이버가 막지는 않겠습니다만 서버에 과한 부하를 가하는 빠른 수집은 비매너에 해당합니다. 
확실히 필요한 만큼만 적정한 속도로 수집하시길 권장드립니다.

# N2H4 0.21

자잘한 버그들을 해결했습니다. 
데모들을 3개로 나누고, 사용방법을 추가했습니다.
리눅스에서의 인코딩 문제를 해결했습니다.(사실 그냥 우회했습니다. 생각해보니 얼마나 자주 바꿀까 싶기도 하고...)
~~맥은 테스트가 들어오는 대로 공지하겠습니다.~~ 테스트 완료

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

# N2H4 0.2

네이버 뉴스에서 댓글을 가져오는 기능을 추가했습니다.
네이버에서 직접 주는 json 형태로 저장되고 생각보다 복잡하고 많은 데이터가 넘어와서 아직 정리하지 않았습니다. 사람들이 필요한 부분이 다를 것이라 생각해 그대로 두었습니다.
getComment(url) 의 형태로 작성했으며 pageSize, page, sort를 설정할 수 있습니다.
sort는 총 4가지로 "favorite","reply","old","new" 가 있으며
favorite 호감순, reply 답글순, old 과거순, new 최신순 입니다.

댓글 정보인 성별 비율, 연령대 비율 등 데이터도 확인 할 수 있어 유용해 보입니다.
쓸모 없는 데이터도 많아서 한번 정리해서 옵션화 해보겠습니다.
getComment(url)$result$commentList[[1]] 하시면 익숙한 data.frame 형태로 댓글 데이터를 보실 수 있습니다.


# N2H4 0.1

MIT License.<br>
Check code demo/example.R<br>
Please [let me know](mailto:forkonlp@gmail.com) use this package.
