<?php
session_start();
include '../connection.php';

try {
    $conn = getConnection();

    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $username = htmlspecialchars($_POST['username']);
        $email = htmlspecialchars($_POST['email']);
        $password = htmlspecialchars($_POST['password']);

        // Валидация пароля
        $minLength = 8; 
        $specialSymbols = ['!', '@', '#', '$', '%', '^', '&', '*'];

        if (strlen($password) < $minLength) {
            $error = "Password should be at least $minLength characters long.";
        } elseif (!preg_match('/[0-9]/', $password)) {
            $error = "Password should contain at least one digit.";
        } elseif (!preg_match('/[A-Z]/', $password)) {
            $error = "Password should contain at least one uppercase letter.";
        } elseif (!preg_match('/[a-z]/', $password)) {
            $error = "Password should contain at least one lowercase letter.";
        } elseif (strpbrk($password, implode('', $specialSymbols)) === false) {
            $error = "Password should contain at least one special symbol: " . implode(', ', $specialSymbols);
        } else {
            // Проверяем наличие пользователя с таким же email или username
            $stmt = $conn->prepare("SELECT user_id FROM Users WHERE email = ? OR username = ?");
            $stmt->bind_param("ss", $email, $username);
            $stmt->execute();
            $stmt->store_result();

            if ($stmt->num_rows > 0) {
                $error = "Email or username already exists. Please choose another.";
            } else {
                // Хэшируем пароль
                $hashed_password = password_hash($password, PASSWORD_DEFAULT);

                // Вставляем нового пользователя в базу данных
                $stmt = $conn->prepare("INSERT INTO Users (username, email, password_hash) VALUES (?, ?, ?)");
                $stmt->bind_param("sss", $username, $email, $hashed_password);

                if ($stmt->execute()) {
                    $_SESSION['user_id'] = $stmt->insert_id;
                    header("Location: /lab1/index.php");
                    exit();
                } else {
                    $error = "Error: " . $stmt->error;
                }
            }

            $stmt->close();
        }
    }

    closeConnection($conn);
} catch (Exception $e) {
    $errorMessage = "An unexpected error occurred: " . $e->getMessage();

    // Скрипт для вывода ошибок
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

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register</title>
    <link rel="stylesheet" href="/lab1/styles/styles.css">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
    <div class="d-flex justify-content-between align-items-center">
            <h2>Register</h2>
            <button onclick="window.location.href='/lab1/index.php'" type="button" class="btn btn-secondary">Back to Main Page</button>
        </div>
        <?php if (isset($error)): ?>
            <div class="alert alert-danger"><?php echo $error; ?></div>
        <?php endif; ?>
        <form method="post" action="">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            <button type="submit" class="btn btn-primary">Register</button>
        </form>
    </div>
</body>
</html>
