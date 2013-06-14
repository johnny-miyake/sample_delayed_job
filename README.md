## Setup
```sh
$ bundle install
$ rake db:create
$ rake db:migrate
$ ./script/delayed_job start
$ rails console
```

## Usage
Creating a new user.
```ruby
irb > u = User.create name: "johnny"
   (0.2ms)  BEGIN
  SQL (0.3ms)  INSERT INTO `users` (`created_at`, `johnny`, `updated_at`) VALUES ('2013-06-10 03:44:27', 'johnny', '2013-06-10 03:44:27')
   (0.7ms)  COMMIT
=> #<User id: 1, name: "johnny", created_at: "2013-06-10 03:44:27", updated_at: "2013-06-10 03:44:27">
```
Changing its name.
```ruby
irb > u.change_name_after_10_seconds

   (sleeping 10 seconds...)

   (0.2ms)  BEGIN
   (0.4ms)  UPDATE `users` SET `name` = 'johnny_1370835903', `updated_at` = '2013-06-10 03:45:03' WHERE `users`.`id` = 1
   (0.8ms)  COMMIT
=> true
```
Reloading the user (Its name has changed).
```ruby
irb > u.reload
=> #<User id: 1, name: "johnny_1370835903", created_at: "2013-06-10 03:44:27", updated_at: "2013-06-10 03:45:03">
```
Changing its name with delayed_job.
```ruby
irb > u.delay.change_name_after_10_seconds
   (0.1ms)  BEGIN
  SQL (0.4ms)  INSERT INTO `delayed_jobs` (`attempts`, `created_at`, `failed_at`, `handler`, `last_error`, `locked_at`, `locked_by`, `priority`, `queue`, `run_at`, `updated_at`) VALUES (0, '2013-06-10 03:45:27', NULL, '--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/ActiveRecord:User\n attributes:\n id: 1\n name: johnny_1370835903\n created_at: 2013-06-10 03:44:27.460562000 Z\n updated_at: 2013-06-10 03:45:03.467649000 Z\nmethod_name: :change_name_after_10_minutes\nargs: []\n', NULL, NULL, NULL, 0, NULL, '2013-06-10 03:45:27', '2013-06-10 03:45:27')
   (0.7ms)  COMMIT
=> #<Delayed::Backend::ActiveRecord::Job id: 1, priority: 0, attempts: 0, handler: "--- !ruby/object:Delayed::PerformableMethod\nobject:...", last_error: nil, run_at: "2013-06-10 03:45:27", locked_at: nil, failed_at: nil, locked_by: nil, queue: nil, created_at: "2013-06-10 03:45:27", updated_at: "2013-06-10 03:45:27">
```
```
(3 seconds later...)
```
Its name have not been changed yet.
```ruby
irb > u.reload
  User Load (0.4ms)  SELECT `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
=> #<User id: 1, name: "johnny_1370835903", created_at: "2013-06-10 03:44:27", updated_at: "2013-06-10 03:45:03">
```
```
(10 seconds later...)
```
Its name have been changed.
```ruby
irb > u.reload
  User Load (0.6ms)  SELECT `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
=> #<User id: 1, name: "johnny_1370835997", created_at: "2013-06-10 03:44:27", updated_at: "2013-06-10 03:46:37">
```
