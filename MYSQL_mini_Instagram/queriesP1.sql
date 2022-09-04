set @UserID=1;
set @PostID=3;

/* Front Page */
select Post.ID, Username, Post.CreationTime, MediaTypeID, MediaFileUrl, (select count(PostID) from Liking where PostID=Post.ID) as "Likes" from (select FollowerUserID, FolloweeUserID from Following where FollowerUserID=@UserID) Followees, User, Post, PostMedia where User.ID=FolloweeUserID && Post.UserID=followeeUserID && PostMedia.PostID=Post.ID order by CreationTime desc;

/*
Old
select Post.ID, Username, Post.CreationTime, MediaTypeID, MediaFileUrl from (select FolloweeUserID from Following where FollowerUserID=2) as Followees, User, Post, PostMedia where User.ID = FolloweeUserID && Post.UserID = User.ID && PostID = Post.ID order by CreationTime desc;

	(select FolloweeUserID from Following where FollowerUserID=2)	-	This gives us a table of the people who we follow
*/

/* Profile Page */
select U.ID, Username, Website, Bio, ProfileImageUrl, (select Count(UserID) from Post where UserID = U.ID) as "Posts", (select Count(FolloweeUserID) from Following where FolloweeUserID = U.ID) as "Followers", (select Count(FollowerUserID) from Following where FollowerUserID = U.ID) as "Following" from User U where ID=@UserID;


select P.ID as "Post ID", P.LocationName as "Location Name", MT.Name as "File Type", PM.MediaFileUrl as "URL" from (select * from Post where UserID=@UserID) P, PostMedia PM, MediaType MT where P.ID = PM.PostID and MT.ID = PM.MediaTypeID order by CreationTime desc;


/*	
	(select * from Post where UserID=1)	-	This is a subquery used to get just the posts from user1

	P, PM, MT 				-	Are aliases for the table names we can use
*/


/* Post Details Page */
select Post.ID, (select Username from User where User.ID=UserID) as Username, (Select ProfileImageUrl from User where User.ID=UserID) as ProfilePictureUrl, LocationName, Location, (select count(PostID) from Liking where PostID=Post.ID) as Likes from Post where Post.Id=@PostID;
/*
Old
select Username, ProfileImageUrl, Post.ID as "Post ID", LocationName, Location, (select Count(PostID) from Liking where PostID=Post.ID)as "Likes" from User, Post where User.ID=1 && Post.ID=199;
*/

select ID, MediaTypeID, MediaFileUrl from PostMedia where PostID = @PostID;

select ID, Comment, CreationTime from Comment where PostID = @PostID order by CreationTime;

