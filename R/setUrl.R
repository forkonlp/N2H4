setUrlByCategory<-function(strDate=strDate,endDate=endDate,category=category){




}

setUrlQuery<-function(strDate=strDate,endDate=endDate,query=query,clusterSize=10){

  url<-"http://news.naver.com/main/search/search.nhn?"
  query=URLencode(iconv(query, to="UTF-8"))
  #startDate=2016-01-01&endDate=2016-05-01
  #st=news.all&q_enc=EUC-KR&r_enc=UTF-8&r_format=xml&rp=none&sm=all.basic&ic=all&so=rel.dsc&


}




#&st=news.all&q_enc=EUC-KR&r_enc=UTF-8&r_format=xml&rp=none&sm=all.basic&ic=all&so=rel.dsc&stDate=range:20160101:20160501&detail=1&pd=4&r_cluster2_start=1&r_cluster2_display=10&start=1&display=5&startDate=2016-01-01&endDate=2016-05-01&dnaSo=rel.dsc
#&st=news.all&q_enc=EUC-KR&r_enc=UTF-8&r_format=xml&rp=none&sm=all.basic&ic=all&so=rel.dsc&stDate=range:20160101:20160501&detail=0&pd=4&r_cluster2_start=1&r_cluster2_display=10&start=1&display=5&startDate=2016-01-01&endDate=2016-05-01&dnaSo=rel.dsc

#&st=news.all&q_enc=EUC-KR&r_enc=UTF-8&r_format=xml&rp=none&sm=all.basic&ic=all&so=rel.dsc&stDate=range:20160101:20160501&detail=0&pd=4&r_cluster2_start=1&r_cluster2_display=10&start=1&display=5&startDate=2016-01-01&endDate=2016-05-01&page=2
#&st=news.all&q_enc=EUC-KR&r_enc=UTF-8&r_format=xml&rp=none&sm=all.basic&ic=all&so=rel.dsc&stDate=range:20160101:20160501&detail=1&pd=4&r_cluster2_start=1&r_cluster2_display=10&start=1&display=5&startDate=2016-01-01&endDate=2016-05-01&page=2
