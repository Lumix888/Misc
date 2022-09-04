<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8" />
    <title></title>
  </head>
  <body>
    <form class="" action="#" method="GET">
      <input type="text" name="name" value="" />
      <input tyoe="submit" name="Submit" value=""/>
    </form>
    <a href="index.php">back</a>
  </body>
</html>

<?php
if (isset($GET['name'])) {
    echo "data successfully submitted";
}
?>