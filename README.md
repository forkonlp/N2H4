# N2H4 
[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing) [![License](https://img.shields.io/github/license/mashape/apistatus.svg)](https://opensource.org/licenses/mit-license.php) [![Travis-CI Build Status](https://travis-ci.org/forkonlp/N2H4.png?branch=master)](https://travis-ci.org/forkonlp/N2H4) [![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/forkonlp/N2H4?branch=master&svg=true)](https://ci.appveyor.com/project/forkonlp/N2H4) [[![Coverage status](https://codecov.io/gh/forkonlp/N2H4/branch/master/graph/badge.svg)](https://codecov.io/github/forkonlp/N2H4?branch=master) [![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/N2H4)](https://cran.r-project.org/package=N2H4)

## 네이버 뉴스 크롤링을 위한 도구
#### MIT 라이선스로 자유롭게 사용하셔도 좋으나 star는 제작자를 춤추게 합니다.
###### (MIT 라이선스는 마음껏 쓰되, 출처를 표시해달라는 뜻입니다.)
#### 사용하실 때 출처(링크 표기 가능)를 밝혀주시면 감사하겠습니다.
###### 문의는 [이슈](https://github.com/forkonlp/N2H4/issues/new)로 남겨주세요.    
###### [이슈](https://github.com/forkonlp/N2H4/issues)로 남겨주시면 같은 문제를 겪는 분이 해결하는데 도움이 됩니다.
###### [위키](https://github.com/forkonlp/N2H4/wiki/)에 한글 설명이 준비되어 있습니다.
###### [슬랙](https://forkonlp.slack.com/messages/C53R7L2UT/)에 질문해주셔도 좋습니다. 가입은 [여기](https://forkonlpforslack.herokuapp.com/)에서 메일로 신청해주세요. 자동으로 진행됩니다.
###### [엑셀에서 UTF 8 csv 파일 다루기](https://github.com/forkonlp/N2H4/wiki/%EC%97%91%EC%85%80%EC%97%90%EC%84%9C-UTF-8-csv-%ED%8C%8C%EC%9D%BC-%EB%8B%A4%EB%A3%A8%EA%B8%B0)를 잘 정리해 주신 글이 있어 공유합니다.

###### OS X 10.11.5, Ubuntu 14.04.4 LTS, Windows >= 8 x64 (build 9200) 에서 확인했습니다.

## 설치방법

```
if (!requireNamespace("N2H4")){
  source("https://install-github.me/forkonlp/N2H4")
}
library(N2H4)
```
