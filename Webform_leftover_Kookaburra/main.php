<?php
if ($_COOKIE['breadpitt'] == '1') {
    echo "<p>Private information exposed</p>";
}
else {
    echo "<h1>Not authorized</h1>";
}
?>