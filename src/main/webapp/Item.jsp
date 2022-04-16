<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@page import ="java.util.Arrays" %>
<%@page import ="com.mongodb.MongoClient" %>
<%@page import ="com.mongodb.client.MongoDatabase"%>
<%@page import ="com.mongodb.client.MongoCollection"%>
<%@page import ="com.mongodb.client.AggregateIterable"%>
<%@page import ="com.mongodb.BasicDBObject"%>
<%@page import ="com.mongodb.client.MongoCursor"%>
<%@page import ="org.bson.Document"%>
<html>
<head>
<meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<title>Airbnb</title>
</head>
<body>

<%
	String defaultImage = "Images/defaultImage.jpeg";
	String name = request.getParameter("name");
	System.out.println(name);
%>
<div style="width: 100% display: table; padding: 40px">
<div style="display: table-row; height: 500px;">
<div style=width: 20%; display: table-cell;">
<br><br>
<%
	MongoClient mongoClient = new MongoClient("localhost", 27017);
	System.out.println("MongoDB item Connected...");

	MongoDatabase db = mongoClient.getDatabase("sample_airbnb");
	System.out.println("MongoDatabase item connected...");

	MongoCollection<Document> collection = db.getCollection("listingsAndReviews");
	System.out.println("Collection item connected...");
	
	AggregateIterable<Document> details = collection.aggregate(Arrays.asList(
	        new Document("$match", new Document("name", name)),
	        new Document("$project", new Document("_id", 0).append("name", "$name")
	        		.append("bedrooms", 1).append("beds", 1).append("accommodates", 1)
	        		.append("amenities", 1).append("image" , "$images.picture_url")
	        		.append("host_name", "$host.host_name").append("host_about", "$host.host_about")
	        		.append("host_picture_url", "$host.host_picture_url").append("host_response_time", "$host.host_response_time")
	        		.append("host_is_superhost", "$host.host_is_superhost").append("host_identity_verified", "$host.host_identity_verified")
	        		.append("host_total_listings_count", "$host.host_total_listings_count"))));
	
	MongoCursor<Document> cursor = details.iterator();
	if (cursor == null)
	{
		System.out.println("Name not found...");
%>
		<img src=<%=defaultImage%> alt="Image" height=500 width=700/>
<%
	}
	Document result = null;
	while(cursor.hasNext()){
		result = (Document) cursor.next();
%>
		<img src=<%=result.get("image")%> alt="Image" height=500 width=700/>
	<div style="display: table-cell; font-size: 150%; padding-left: 10px; padding right: 160px">
	<tr>
	<p> Name: 
	<td>
		<%=result.getString("name")%>
	</td>
	</tr>
	<tr>
	<p> Bedrooms: 
	<td>
		<%=result.getInteger("bedrooms")%>
	</td>
	</tr>
	<tr>
	<p> Beds: 
	<td>
		<%=result.getInteger("beds")%>
	</td>
	</tr>
	<tr>
	<p> Accommodates: 
	<td>
		<%=result.getInteger("accommodates")%>
	</td>
	</tr>
	<tr>
	<p> Amenities: 
	<td>
		<%=result.get("amenities")%>
	</td>
	<td>
	<%=result.get("host_name") %>
	</td>
	</tr>
	</div>
<%	
	}
%>

<h2>Host</h2>

    <div style="float:left">
        <img src=<%=result.get("host_picture_url")%> style="padding: 15px" height=200 width=200 >
    </div>

    <div style="float:left">
        <table class="table">
            <tbody>
            <tr>
                <td scope="col" >Name</td>
                <td><%=result.get("host_name") %></td>
            </tr>
            <tr>
                <td scope="col" >About</td>
                <td><%=result.get("host_about") %></td>
            </tr>
            <tr>
                <td scope="col" >Response time</td>
                <td><%=result.get("host_respose_time") %></td>
            </tr>
            <tr>
                <td scope="col" >Superhost</td>
                <td><%=result.get("host_is_superhost") %></td>
            </tr>
            <tr>
                <td scope="col" >Verified</td>
                <td><%=result.get("host_identity_verified") %></td>
            </tr>
            <tr>
                <td scope="col" >Total listings</td>
                <td><%=result.get("host_total_listings_count") %></td>
            </tr>
            </tbody>
        </table>

    </div>

<iframe
  width="450"
  height="250"
  frameborder="0" style="border:0"
  referrerpolicy="no-referrer-when-downgrade"
  src="https://www.google.com/maps/embed/v1/view?key=AIzaSyDR7rVIIlwy-hBxcKz51VYLVo-rXUNDeRY&center=-33.8569,151.2152&zoom=18"
  allowfullscreen>
</iframe>
</div>
</body>
</html>


