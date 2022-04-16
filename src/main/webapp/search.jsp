<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@page import ="java.util.Arrays" %>
<%@page import ="com.mongodb.MongoClient" %>
<%@page import ="com.mongodb.client.MongoDatabase"%>
<%@page import ="com.mongodb.client.MongoCollection"%>
<%@page import ="com.mongodb.client.FindIterable"%>
<%@page import ="com.mongodb.client.MongoIterable"%>
<%@page import ="com.mongodb.client.AggregateIterable"%>
<%@page import ="com.mongodb.client.MongoCursor"%>
<%@page import ="com.mongodb.BasicDBObject"%>
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
<img src="Images/logo.png" class="center" align="center" alt="Airbnb" height="300" width ="1000"/>
<br><br>

<div class="container">
  <table class="table">
    <thead>
      <tr>
	<th class="bg-primary">Image</th>
	<th class="bg-primary">Name</th>
	<th class="bg-primary">Bedrooms</th>
	<th class="bg-primary">Accommodates</th>
	<th class="bg-primary">Address</th>

</tr>
    </thead>



<%
	MongoClient mongoClient = new MongoClient("localhost", 27017);
	System.out.println("MongoDB search Connected...");

	MongoDatabase db = mongoClient.getDatabase("sample_airbnb");
	System.out.println("MongoDatabase search connected...");
	
	MongoCollection<Document> collection = db.getCollection("listingsAndReviews");
	System.out.println("Collection search connected...");
	
	//Document regexQuery = new Document();
	//regexQuery.append("$regex", ".*(?i)" + request.getParameter("name") + ".*");
	
	//BasicDBObject query = new BasicDBObject("name", regexQuery);
	
	//FindIterable<Document> iter = collection.find(query).sort(new BasicDBObject("title", 1));
	
	AggregateIterable<Document> details = collection.aggregate(Arrays.asList(
	        new Document("$match", new Document("name", new Document("$regex", ".*(?i)" + request.getParameter("name") + ".*"))),
	        new Document("$project", new Document("_id", 0).append("name", "$name").append("bedrooms", 1)
	        		.append("accommodates", 1).append("address", "$address.country").append("image" , "$images.picture_url"))));
	MongoCursor<Document> cursor = details.iterator();
	Document result = null;
	while(cursor.hasNext()){
		result = (Document) cursor.next();
%>

    <tbody>
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
			<%=result.getInteger("bedrooms") %>
		</td>
		<td>
			<%=result.getInteger("accommodates") %>
		</td>
		<td>
			<%=result.get("address") %>
		</td>
	</tr>
    </tbody>

<%
	}
%>
</table>
</body>
</html>
<style type="text/css">
.center {
  display: block;
  margin-left: auto;
  margin-right: auto;
  width: 50%;
}</style>