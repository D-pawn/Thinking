<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,java.io.*,javax.servlet.*,java.security.*" %>
<%! 
    int pageNow=1;
    int rowCount=0;
    int pageSize=15;
    int pageDisplayStep=2;
    boolean ajaxTrigger=false;//undo
	//分页
    String getPaging(String url,String params){
        int pageCount=getPageCount();
        int pageStart=getPageIndex(true);
        int pageEnd=getPageIndex(false);
        String result="";
        //首
        if(pageNow>1){
            result+=getHtml(pageNow-1,url,params,"上一页","");
        }
        if(pageStart!=1){
            for(int i=1;i<=pageDisplayStep;i++){
                result+=getHtml(i,url,params,"["+i+"]","");
            }
            result+="[...]";
        }
        //主体
        for(int i=pageStart;i<=pageEnd;i++){
            String style="";
            if(pageNow==i){
                style=" style='color:red' ";
            }
            result+=getHtml(i,url,params,"["+i+"]",style);
        }
        //尾
        if(pageEnd!=pageCount){ 
            result+="[...]";
            for(int i=pageCount-pageDisplayStep+1;i<=pageCount;i++){
                result+=getHtml(i,url,params,"["+i+"]","");
            }
        }
        if(pageNow<pageCount){
            result+=getHtml(pageNow+1,url,params,"下一页","");
        }
        result+="&nbsp;&nbsp;&nbsp;&nbsp;共计："+rowCount+"条数据";
        return result;
    }
     //页面数
	int getPageCount(){
		int result=rowCount/pageSize;
		if(rowCount%pageSize!=0){
			result+=1;
		}
		return result;
	}
    //<URL>标签
    String getHtml(int page,String url,String params,String displayString,String style){
        return "<a "+style+" href="+url+"?pageNow="+page+params+">"+displayString+"</a>";
    }
    //起始，起止页数--true:pageStart,false:pageEnd
    int getPageIndex(boolean head){
        int step=head?-pageDisplayStep:pageDisplayStep;
        int pageIndex=pageNow+step+(head?-getOutSide(!head):getOutSide(!head));
        int sideNum=head?1:getPageCount();
        int temp=head?-(sideNum-pageIndex):(sideNum-pageIndex);
        if(temp<0 || !(temp>=2*pageDisplayStep)){
            pageIndex=sideNum;
        }
        return pageIndex;
    }
    //越界距离--Math.abs()
    int getOutSide(boolean head){
        int sideNum=head?1:getPageCount();
        int step=head?-pageDisplayStep:pageDisplayStep;
        int result=head?-(pageNow+step-sideNum):(pageNow+step-sideNum);
        if(result<0){
            result=0;//正常范围
        }
        return result;
    }
    

    //optional:从<request>中获取当前页,def:1
	int getPageNow(HttpServletRequest request,String paramName){
		int result=1;
		try {
			result=Integer.parseInt(request.getParameter(paramName));		
		} catch (Exception e) {
			result=1;
		}
		return result;
	}

%>
