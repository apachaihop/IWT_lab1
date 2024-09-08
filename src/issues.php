<?php
include 'connection.php';
include '../includes/header.php';

$conn = getConnection();

$sql = "SELECT title, description, status FROM Issues";
$result = $conn->query($sql);

echo "<h1>Issues</h1>";
if ($result->num_rows > 0) {
    echo "<table class='table table-bordered'>
            <thead class='thead-light'>
                <tr>
                    <th>Title</th>
                    <th>Description</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>";
    while($row = $result->fetch_assoc()) {
        echo "<tr>
                <td>" . $row["title"]. "</td>
                <td>" . $row["description"]. "</td>
                <td>" . $row["status"]. "</td>
              </tr>";
    }
    echo "</tbody></table>";
} else {
    echo "<div class='alert alert-warning' role='alert'>No issues found.</div>";
}

closeConnection($conn);
include '../includes/footer.php';
?>