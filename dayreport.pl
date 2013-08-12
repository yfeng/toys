use strict;
use warnings;
use WWW::Mechanize;
use Carp;
use Encode qw/ encode decode /;
use utf8;

use 5.14.0;
use LWP::UserAgent;
use LWP::Simple;
use HTTP::Cookies;
use FindBin qw($Bin);


our $domain="http://timesheetv2.paic.com.cn/timesheet";
our $cookie_jar  = HTTP::Cookies->new(  
	        file        => $Bin."/cookies.lwp",  
	        autosave    => 1,  
	        );
#my $days = ["2013-04-19"];
my @days = &getDay();
#say @days;
# say "开始处理日报....";
&submit($_)  for @days;

sub getDay{
	my @skipDay = @_;	
	my @days;
	foreach my $day (17) {
		$day= "0".$day if($day < 10);
		next if(grep {$_==$day} @skipDay);
		
		push @days,"2013-05-".$day;
	}
	return @days;
}

sub submit{
	my $day = shift;  

	my $data = 'isEditTimeSheet=N&empNum=E00010083472&departmentId=PA011_S000033307&isSubstitute=N&workDate=&edit_proj_time_label=0&systemWorkTimes%5B0%5D.statusT=&systemWorkTimes%5B0%5D.taskOwner=CS_640886&systemWorkTimes%5B0%5D.taskOwnerInput=WORKNET-ENGINE%3A%BA%CB%D0%C4%D2%FD%C7%E6%B7%FE%CE%F1&systemWorkTimes%5B0%5D.taskOwnerSelect=CS_640886&systemWorkTimes%5B0%5D.customer=sponsor026&systemWorkTimes%5B0%5D.interProjId=&systemWorkTimes%5B0%5D.serviceNo=stask024_2013&systemWorkTimes%5B0%5D.serviceItems=%D3%A6%D3%C3%CF%B5%CD%B3%D4%CB%D3%AA%D6%A7%B3%D6%B7%FE%CE%F1--%3EPER%BF%AA%B7%A2%B7%FE%CE%F1--%3EPER%BF%AA%B7%A2--%3E%D6%D0%BC%E4%BC%FE%2F%CD%A8%D3%C3%C6%BD%CC%A8%B9%DC%C0%ED&systemWorkTimes%5B0%5D.serviceItemSelect=stask024_2013*%D3%A6%D3%C3%CF%B5%CD%B3%D4%CB%D3%AA%D6%A7%B3%D6%B7%FE%CE%F1--%3EPER%BF%AA%B7%A2%B7%FE%CE%F1--%3EPER%BF%AA%B7%A2--%3E%D6%D0%BC%E4%BC%FE%2F%CD%A8%D3%C3%C6%BD%CC%A8%B9%DC%C0%ED*1@1@null@null@null@null%244@1@null@null@null@null&systemWorkTimes%5B0%5D.projectId=&systemWorkTimes%5B0%5D.taskIdDisplay=d9-cd-ptgl&systemWorkTimes%5B0%5D.taskId=d9-cd-ptgl&systemWorkTimes%5B0%5D.srNo=&systemWorkTimes%5B0%5D.needType=%C4%DA%B2%BF%D0%E8%C7%F3&systemWorkTimes%5B0%5D.taskDetailDisplay=&systemWorkTimes%5B0%5D.taskDetail=&systemWorkTimes%5B0%5D.remark=%D2%F8%D0%D0%CD%A8%D3%C3%C6%BD%CC%A8%BC%BC%CA%F5%D6%A7%B3%D6&systemWorkTimes%5B0%5D.costHours=7.58&edit_per_time_label=7.58&edit_daily_time_label=0&edit_sum_time_label=7.58&projectWorkTimeItem=&systemWorkTimeItem=1&dailyWorkTimeItem=';

	$data=~s/workDate=/workDate=$day/g;
	# say $data;

	 my $ua = LWP::UserAgent->new;
	 $ua->agent('Mozilla/5.0 (Windows NT 6.1; rv:18.0) Gecko/20100101 Firefox/18.0');
	 $ua->timeout(5);
	 # $ua->proxy(['http'], 'http://127.0.0.1:8080/');
	 $ua->cookie_jar($cookie_jar);  

	 my $req = HTTP::Request->new(POST => "$domain/j_security_check");
		$req->header('Accept' => 'text/html',
					 'Host' => 'timesheetv2.paic.com.cn',
					 'Referer' => "$domain/login.jsp",
					 'Accept-Encoding' => "gzip, deflate",
					 'Accept-Language' => "zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3",
					 'Connection' => "keep-alive");

	    $req->content_type('application/x-www-form-urlencoded');
	    $req->content("j_username=ex-raoqinian001&j_password=RAOQINIAN11576");
	 my $res = $ua->request($req);
	 my $redirect_to = $res->header('location');  
	 my $req2 = HTTP::Request->new(GET=>$redirect_to);  
	 $cookie_jar->add_cookie_header($req2);    
	 $ua->request($req2); #location to Main page
	 
	 my $req3   = HTTP::Request->new(GET=>"$domain/createSheet.do?workDate=".$day);  
	 $ua->request($req3); #location to 2013-03-30 page

	 my $req4 = HTTP::Request->new(POST=>"$domain/createSheet.do"); 
	    $req4->header('Accept' => 'image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/x-shockwave-flash, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*',
					  'Connection' => "keep-alive",
				      'Accept-Encoding' => "gzip, deflate",
					  'Accept-Language' => "zh-CN",
					  'Pragma' => "no-cache",
					  'Referer' => "$domain/createSheet.do?workDate=$day");
	   $req4->content_type('application/x-www-form-urlencoded');
	
	 
	   $req4->content($data);
	my $res4 = $ua->request($req4);  
	my $html = decode 'GBK',$res4->content;
	 
	if($html=~m/操作成功/){
		say $day." submit success!!";
	}
	else{
	   say "submit fail";
	}
}


# __DATA__
# isEditTimeSheet=N&empNum=E00010083472&departmentId=PA011_S000033307&isSubstitute=N&workDate=&edit_proj_time_label=0&systemWorkTimes%5B0%5D.statusT=&systemWorkTimes%5B0%5D.taskOwner=CS_640886&systemWorkTimes%5B0%5D.taskOwnerInput=WORKNET-ENGINE%3A%BA%CB%D0%C4%D2%FD%C7%E6%B7%FE%CE%F1&systemWorkTimes%5B0%5D.taskOwnerSelect=CS_640886&systemWorkTimes%5B0%5D.customer=sponsor026&systemWorkTimes%5B0%5D.interProjId=&systemWorkTimes%5B0%5D.serviceNo=stask024_2013&systemWorkTimes%5B0%5D.serviceItems=%D3%A6%D3%C3%CF%B5%CD%B3%D4%CB%D3%AA%D6%A7%B3%D6%B7%FE%CE%F1--%3EPER%BF%AA%B7%A2%B7%FE%CE%F1--%3EPER%BF%AA%B7%A2--%3E%D6%D0%BC%E4%BC%FE%2F%CD%A8%D3%C3%C6%BD%CC%A8%B9%DC%C0%ED&systemWorkTimes%5B0%5D.serviceItemSelect=stask024_2013*%D3%A6%D3%C3%CF%B5%CD%B3%D4%CB%D3%AA%D6%A7%B3%D6%B7%FE%CE%F1--%3EPER%BF%AA%B7%A2%B7%FE%CE%F1--%3EPER%BF%AA%B7%A2--%3E%D6%D0%BC%E4%BC%FE%2F%CD%A8%D3%C3%C6%BD%CC%A8%B9%DC%C0%ED*1@1@null@null@null@null%244@1@null@null@null@null&systemWorkTimes%5B0%5D.projectId=&systemWorkTimes%5B0%5D.taskIdDisplay=9999999999999&systemWorkTimes%5B0%5D.taskId=9999999999999&systemWorkTimes%5B0%5D.srNo=&systemWorkTimes%5B0%5D.needType=%C4%DA%B2%BF%D0%E8%C7%F3&systemWorkTimes%5B0%5D.taskDetailDisplay=&systemWorkTimes%5B0%5D.taskDetail=&systemWorkTimes%5B0%5D.remark=88888888888888888888888888888&systemWorkTimes%5B0%5D.costHours=7.58&edit_per_time_label=7.58&edit_daily_time_label=0&edit_sum_time_label=7.58&projectWorkTimeItem=&systemWorkTimeItem=1&dailyWorkTimeItem=
