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
	        		.append("amenities", 1).append("image" , "$images.picture_url"))));
	
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
	</tr>
	</div>
<%	
	}
%>
</div>
</body>
</html>


