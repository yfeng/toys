#coding=utf-8
import requests
import re
import chardet
'''
一个自动填写平安日报的工具
'''
username='ex-raoqinian001'
passwd='RAOQINIAN11576'
domain="http://timesheetv2.paic.com.cn/timesheet"
headers = {
'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; rv:18.0) Gecko/20100101 Firefox/18.0',
'Accept' : 'text/html',
'Host' : 'timesheetv2.paic.com.cn',
'Referer' : domain+"/login.jsp",
'Accept-Encoding' : "gzip, deflate",
'Accept-Language' : "zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3",
'Connection' : "keep-alive",
"content-type":"application/x-www-form-urlencoded"
}

def submit(day):
	s = requests.session()
	r = s.post(domain+'/j_security_check',headers=headers,data={"j_username":username,"j_password":passwd})
	r = s.get(domain+"/createSheet.do?workDate="+day)
	data = 'isEditTimeSheet=N&empNum=E00010083472&departmentId=PA011_S000033307&isSubstitute=N&workDate=&edit_proj_time_label=0&systemWorkTimes%5B0%5D.statusT=&systemWorkTimes%5B0%5D.taskOwner=CS_640886&systemWorkTimes%5B0%5D.taskOwnerInput=WORKNET-ENGINE%3A%BA%CB%D0%C4%D2%FD%C7%E6%B7%FE%CE%F1&systemWorkTimes%5B0%5D.taskOwnerSelect=CS_640886&systemWorkTimes%5B0%5D.customer=sponsor026&systemWorkTimes%5B0%5D.interProjId=&systemWorkTimes%5B0%5D.serviceNo=stask024_2013&systemWorkTimes%5B0%5D.serviceItems=%D3%A6%D3%C3%CF%B5%CD%B3%D4%CB%D3%AA%D6%A7%B3%D6%B7%FE%CE%F1--%3EPER%BF%AA%B7%A2%B7%FE%CE%F1--%3EPER%BF%AA%B7%A2--%3E%D6%D0%BC%E4%BC%FE%2F%CD%A8%D3%C3%C6%BD%CC%A8%B9%DC%C0%ED&systemWorkTimes%5B0%5D.serviceItemSelect=stask024_2013*%D3%A6%D3%C3%CF%B5%CD%B3%D4%CB%D3%AA%D6%A7%B3%D6%B7%FE%CE%F1--%3EPER%BF%AA%B7%A2%B7%FE%CE%F1--%3EPER%BF%AA%B7%A2--%3E%D6%D0%BC%E4%BC%FE%2F%CD%A8%D3%C3%C6%BD%CC%A8%B9%DC%C0%ED*1@1@null@null@null@null%244@1@null@null@null@null&systemWorkTimes%5B0%5D.projectId=&systemWorkTimes%5B0%5D.taskIdDisplay=d9-cd-ptgl&systemWorkTimes%5B0%5D.taskId=d9-cd-ptgl&systemWorkTimes%5B0%5D.srNo=&systemWorkTimes%5B0%5D.needType=%C4%DA%B2%BF%D0%E8%C7%F3&systemWorkTimes%5B0%5D.taskDetailDisplay=&systemWorkTimes%5B0%5D.taskDetail=&systemWorkTimes%5B0%5D.remark=%D2%F8%D0%D0%CD%A8%D3%C3%C6%BD%CC%A8%BC%BC%CA%F5%D6%A7%B3%D6&systemWorkTimes%5B0%5D.costHours=7.58&edit_per_time_label=7.58&edit_daily_time_label=0&edit_sum_time_label=7.58&projectWorkTimeItem=&systemWorkTimeItem=1&dailyWorkTimeItem='
	data = re.sub('workDate=','workDate='+day,data)
	r =	s.post(domain+"/createSheet.do",headers=headers,data=data)
	if re.search(ur"操作成功".encode(chardet.detect(r.content)['encoding']),r.content) is not None:
		print(day+" submit success!")
	else:
		print("submit faild!")
if __name__ == '__main__':
    year='2013'
    month='07'
    skip=[6,7,13,14]
    [submit(year+'-'+month+'-'+str(i)) for i in range(1,19) if i not in skip]
