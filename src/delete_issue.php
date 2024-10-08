<?php
include 'connection.php';

$conn = getConnection();

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $issue_id = htmlspecialchars($_POST['issue_id']);

    $stmt = $conn->prepare("DELETE FROM Issues WHERE issue_id = ?");
    if ($stmt === false) {
        die('Prepare failed: ' . htmlspecialchars($conn->error));
    }

    $stmt->bind_param("i", $issue_id);
    if ($stmt->execute() === false) {
        die('Execute failed: ' . htmlspecialchars($stmt->error));
    }

    $stmt->close();
}

closeConnection($conn);

header("Location: issues.php");
exit();
?>