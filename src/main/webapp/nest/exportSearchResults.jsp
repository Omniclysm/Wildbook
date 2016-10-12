<%@ page contentType="text/html; charset=utf-8" language="java"
         import="org.ecocean.servlet.ServletUtilities,java.util.Vector,java.util.Properties,org.ecocean.genetics.*,java.util.*,java.net.URI, org.ecocean.*" %>


  <%
  String context="context0";
  context=ServletUtilities.getContext(request);

    //let's load encounterSearch.properties
    //String langCode = "en";
    String langCode=ServletUtilities.getLanguageCode(request);

    Properties map_props = new Properties();
    map_props=ShepherdProperties.getProperties("exportSearchResults.properties", langCode, context);

		Properties collabProps = new Properties();
 		collabProps=ShepherdProperties.getProperties("collaboration.properties", langCode, context);


    Properties nestprops = new Properties();
    nestprops=ShepherdProperties.getProperties("nestSearchResults.properties", langCode, context);

    //get our Shepherd
    Shepherd myShepherd = new Shepherd(context);

    //set up the vector for matching encounters
    Vector rEncounters = new Vector();

    //kick off the transaction
    myShepherd.beginDBTransaction();

    //start the query and get the results
    String order = "";
    //request.setAttribute("gpsOnly", "yes");

    Vector blocked=new Vector();

    try{
		    	NestQueryResult queryResult = NestQueryProcessor.processQuery(myShepherd, request, order);
		    	rEncounters = queryResult.getResult();


		  %>

		    <style type="text/css">




		      #map {
		        width: 600px;
		        height: 400px;
		      }

		    </style>


		<style type="text/css">
		  #tabmenu {
		    color: #000;
		    border-bottom: 1px solid #CDCDCD;
		    margin: 12px 0px 0px 0px;
		    padding: 0px;
		    z-index: 1;
		    padding-left: 10px
		  }

		  #tabmenu li {
		    display: inline;
		    overflow: hidden;
		    list-style-type: none;
		  }

		  #tabmenu a, a.active {
		    color: #000;
		    background: #E6EEEE;

		    border: 1px solid #CDCDCD;
		    padding: 2px 5px 0px 5px;
		    margin: 0;
		    text-decoration: none;
		    border-bottom: 0px solid #FFFFFF;
		  }

		  #tabmenu a.active {
		    background: #8DBDD8;
		    color: #000000;
		    border-bottom: 1px solid #8DBDD8;
		  }

		  #tabmenu a:hover {
		    color: #000;
		    background: #8DBDD8;
		  }

		  #tabmenu a:visited {

		  }

		  #tabmenu a.active:hover {
		    color: #000;
		    border-bottom: 1px solid #8DBDD8;
		  }

		</style>

		    <jsp:include page="../header.jsp" flush="true"/>

		    <div class="container maincontent">


		      <h1 class="intro"><%=map_props.getProperty("title")%>
		      </h1>



          <ul id="tabmenu">

            <li><a href="searchResults.jsp?<%=request.getQueryString() %>"><%=nestprops.getProperty("table")%>
            </a></li>
            <li><a class="active"
               href="exportSearchResults.jsp?<%=request.getQueryString() %>"><%=nestprops.getProperty("export")%>
             </a></li>

          </ul>

		<% if (blocked.size() < 1) { %>

		 <p><strong><%=map_props.getProperty("exportOptions")%></strong></p>

		<p><%=map_props.getProperty("exportedSwot")%>: <a href="http://<%=CommonConfiguration.getURLLocation(request)%>/SwotExport?<%=request.getQueryString()%>"><%=map_props.getProperty("clickHere")%></a>
		</p>

		<p><%=map_props.getProperty("exportedEmail")%>: <a
		  href="http://<%=CommonConfiguration.getURLLocation(request)%>/EncounterSearchExportEmailAddresses?<%=request.getQueryString()%>"><%=map_props.getProperty("clickHere")%>
		</a>
		</p>

		<% } else { // dont have access to ALL records, so:  %>

		<p><%=collabProps.getProperty("functionalityBlockedMessage")%></p>

		<% } %>

		 <table>
		  <tr>
		    <td align="left">

		      <p><strong><%=map_props.getProperty("queryDetails")%>
		      </strong></p>

		      <p class="caption"><strong><%=map_props.getProperty("prettyPrintResults") %>
		      </strong><br/>
		        <%=queryResult.getQueryPrettyPrint().replaceAll("locationField", map_props.getProperty("location")).replaceAll("locationCodeField", map_props.getProperty("locationID")).replaceAll("verbatimEventDateField", map_props.getProperty("verbatimEventDate")).replaceAll("alternateIDField", map_props.getProperty("alternateID")).replaceAll("behaviorField", map_props.getProperty("behavior")).replaceAll("Sex", map_props.getProperty("sex")).replaceAll("nameField", map_props.getProperty("nameField")).replaceAll("selectLength", map_props.getProperty("selectLength")).replaceAll("numResights", map_props.getProperty("numResights")).replaceAll("vesselField", map_props.getProperty("vesselField"))%>
		      </p>

		      <p class="caption"><strong><%=map_props.getProperty("jdoql")%>
		      </strong><br/>
		        <%=queryResult.getJDOQLRepresentation()%>
		      </p>

		    </td>
		  </tr>
		</table>

		</div>
<%

    }
    catch(Exception e){e.printStackTrace();}
    finally{
    	myShepherd.rollbackDBTransaction();
    	myShepherd.closeDBTransaction();
    }

 %>

 <jsp:include page="../footer.jsp" flush="true"/>