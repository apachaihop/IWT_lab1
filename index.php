<?php
include './includes/header.php';
include './src/connection.php';
try {
    $conn = getConnection();

    $repoCount = $conn->query("SELECT COUNT(*) AS count FROM Repositories")->fetch_assoc()['count'];
    $issueCount = $conn->query("SELECT COUNT(*) AS count FROM Issues")->fetch_assoc()['count'];
    $prCount = $conn->query("SELECT COUNT(*) AS count FROM PullRequests")->fetch_assoc()['count'];
    $userCount = $conn->query("SELECT COUNT(*) AS count FROM Users")->fetch_assoc()['count'];

    closeConnection($conn);
} catch (Exception $e) {
    $errorMessage = "An unexpected error occurred: " . $e->getMessage();
    $repoCount = $issueCount = $prCount = $userCount = 0;

    // Add the following block to display more context about the error
    echo "<script type='text/javascript'>
            let errorDetails = 'An error occurred while processing the data.\\n\\n';
            errorDetails += 'Possible causes could include:\\n';
            errorDetails += '- Database connection issue\\n';
            errorDetails += '- Query failure\\n';
            errorDetails += '- Invalid data\\n\\n';
            errorDetails += 'Technical details: " . addslashes($errorMessage) . "';
            alert(errorDetails);
          </script>";
}
?>

<h1>Welcome to the VCS Project</h1>
<p>Select an option from the navigation menu to get started.</p>

<div class="row">
    <div class="col-md-3">
        <div class="card text-white bg-primary mb-3">
            <div class="card-header">Repositories</div>
            <div class="card-body">
                <h5 class="card-title"><?php echo $repoCount; ?></h5>
                <p class="card-text">Total Repositories</p>
                <a href="./src/repositories.php" class="btn btn-light">View Repositories</a>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card text-white bg-secondary mb-3">
            <div class="card-header">Issues</div>
            <div class="card-body">
                <h5 class="card-title"><?php echo $issueCount; ?></h5>
                <p class="card-text">Total Issues</p>
                <a href="./src/issues.php" class="btn btn-light">View Issues</a>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card text-white bg-success mb-3">
            <div class="card-header">Pull Requests</div>
            <div class="card-body">
                <h5 class="card-title"><?php echo $prCount; ?></h5>
                <p class="card-text">Total Pull Requests</p>
                <a href="./src/pull_requests.php" class="btn btn-light">View Pull Requests</a>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card text-white bg-danger mb-3">
            <div class="card-header">Users</div>
            <div class="card-body">
                <h5 class="card-title"><?php echo $userCount; ?></h5>
                <p class="card-text">Total Users</p>
                <a href="./src/users.php" class="btn btn-light">View Users</a>
            </div>
        </div>
    </div>
</div>

<h2>Submit a Review</h2>


<form action="./src/submit_review.php" method="post">
    <div class="form-group">
        <div class="row">
            <div class="col-md-6">
                <label for="review">Review</label>
            </div>
            <div class="col-md-6 text-right">
                <a href="./src/reviews.php">View Reviews</a>
            </div>
        </div>
        <textarea class="form-control" id="review" name="review" rows="3" required></textarea>
    </div>
    <button type="submit" class="btn btn-primary">Submit</button>
</form>

<?php
include './includes/footer.php';
?>