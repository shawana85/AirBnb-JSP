<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@page import ="java.util.Arrays" %>
<%@page import ="com.mongodb.MongoClient" %>
<%@page import ="com.mongodb.client.MongoDatabase"%>
<%@page import ="com.mongodb.client.MongoCollection"%>
<%@page import ="com.mongodb.client.AggregateIterable"%>
<%@page import ="com.mongodb.client.MongoIterable"%>
<%@page import ="com.mongodb.client.MongoCursor"%>
<%@page import ="com.mongodb.BasicDBObject"%>
<%@page import ="org.bson.Document"%>
<html>
<head>
<meta charset="UTF-8">
<title>Airbnb</title>
</head>
<body>
<img src="Images/logo.png" class="center" alt="Airbnb" height="300" width ="1000"/>
<br><br>
<div  class = "center">
<form action = "search.jsp">
<p style = "color : black"> Search places: <br>
<input type="text" name = "name"
		style = "width : 360px; height : 40px; font-size:20px;">
<input type= "submit" style= "height:50px">

</p>
</form>
</div>
<h1> Popular Stays!</h1>
<div>
<table border ="1" align="center" style="font-size:100%;">
<tr>
	<th style="background-color:#d2d8c7">name</th>
	<th style="background-color:#d2d8c7">image</th>
	<th style="background-color:#d2d8c7">review</th>

</tr>
<%
	MongoClient mongoClient = new MongoClient("localhost", 27017);
	System.out.println("MongoDB Connected...");

	MongoDatabase db = mongoClient.getDatabase("sample_airbnb");
	System.out.println("MongoDatabase connected...");
	
	MongoCollection<Document> collection = db.getCollection("listingsAndReviews");
	System.out.println("Collection connected...");
	AggregateIterable<Document> popularStays = collection.aggregate(Arrays.asList(
	        new Document("$unwind", "$review_scores"),
	        new Document("$sort", new Document("review_scores.review_scores_rating", -1)),
	        new Document("$project", new Document("_id", 0).append("name", "$name").append("review", "$review_scores.review_scores_rating")
	        	    .append("image", "$images.picture_url")),
	        new Document("$limit", 5)
	        ));
	MongoCursor<Document> cursor = popularStays.iterator();
	Document result = null;
	while(cursor.hasNext()){
		result = (Document) cursor.next();
%>
	<tr>
		<td>
		<img src=<%=result.get("image")%> alt="Image" height=250 width=350/>
		</td>
		<td>
		<a href="Item.jsp?name=<%=result.getString("name") %>">
			<%=result.getString("name") %>
			</a>
		</td>
		<td>
			<%=result.get("review")%>
		</td>
	</tr>
<%
	}
%>
</table>
</div>
</body>
</html>
<style type="text/css">
.center {
  display: block;
  margin-left: auto;
  margin-right: auto;
  width: 50%;
}
</style>