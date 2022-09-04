/* total users || total posts */
select count(ID) from User;		
select count(ID) from Post;


/* avg posts */
select avg(P.Posts) as "Average Posts" from (select Username, (select count(UserID) from Post where UserID=User.ID) as "Posts" from User) P; 


/* avg comments */
select avg(CPU.ComNum) as "Average Comments" from (select (select count(ID) from Comment where PostID=Post.ID) as "ComNum" from Post) CPU; 


/* avg likes */
select avg((select count(PostID) from Liking where PostID = Post.ID)) as "Average Likes" from Post; 


/* D Whole Modafaka Query =D Waaat? */
select (select count(ID) from User) as "Total Users", (select count(ID) from Post) as "Total Posts", avg(PostNum.Posts) as "Average Posts", max(PostNum.Posts) as "Max Posts", (select avg(CPU.ComNum) from (select (select count(ID) from Comment where PostID=Post.ID) as "ComNum" from Post) CPU) as "Average Comments", (select max(CPU.ComNum) from (select (select count(ID) from Comment where PostID=Post.ID) as "ComNum" from Post) CPU) as "Max Comments", (select avg((select count(PostID) from Liking where PostID = Post.ID)) from Post) as "Average Likes", (select max((select count(PostID) from Liking where PostID = Post.ID)) from Post) as "Max Likes" from (select Username, (select count(UserID) from Post where UserID=User.ID) as "Posts" from User) PostNum;


/* top 10 users with most posts */
select ID, Username, (select count(ID) from Post where UserID=User.ID) as NumPosts from User order by NumPosts desc limit 10;


/* Number of Registrations per day */
select date(CreationTime) as Date, count(CreationTime) as "Number of Registrations" from User group by Date(CreationTime);
/* CreationTime is timestamp and it also contains time, so we use date() to just get the date and group by just date */


/* User division by gender */
select (select Name from Gender where ID=GenderID) as Gender, count(GenderID) as "Number of Users" from User group by GenderID;

