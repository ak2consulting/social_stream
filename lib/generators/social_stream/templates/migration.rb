class CreateSocialStream < ActiveRecord::Migration
  def self.up
    create_table "activities", :force => true do |t|
      t.integer  "activity_verb_id"
      t.integer  "tie_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "ancestry"
    end

    add_index "activities", ["activity_verb_id"], :name => "fk_activity_verb"
    add_index "activities", ["tie_id"], :name => "fk_activities_tie"

    create_table "activity_object_activities", :force => true do |t|
      t.integer  "activity_id"
      t.integer  "activity_object_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "type",               :limit => 45
    end

    add_index "activity_object_activities", ["activity_id"], :name => "fk_activity_object_activities_1"
    add_index "activity_object_activities", ["activity_object_id"], :name => "fk_activity_object_activities_2"

    create_table "activity_objects", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "object_type", :limit => 45
    end

    create_table "activity_verbs", :force => true do |t|
      t.string   "name",       :limit => 45
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "actors", :force => true do |t|
      t.string   "name",      :limit => 45
      t.string   "email",     :default => "", :null => false
      t.string   "permalink", :limit => 45
      t.string   "subject_type", :limit => 45
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "activity_object_id"
      t.string   "logo_file_name"
      t.string   "logo_content_type"
      t.integer  "logo_file_size"
      t.datetime "logo_updated_at"
    end

    add_index "actors", ["activity_object_id"], :name => "fk_actors_activity_object"
    add_index "actors", ["email"], :name => "index_actors_on_email"
    add_index "actors", ["permalink"], :name => "index_actors_on_permalink", :unique => true

    create_table "comments", :force => true do |t|
      t.integer  "activity_object_id"
      t.text     "text"
      t.datetime "updated_at"
      t.datetime "created_at"
    end

    add_index "comments", ["activity_object_id"], :name => "fk_commets_activity_object"

    create_table "groups", :force => true do |t|
      t.integer  "actor_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "groups", ["actor_id"], :name => "fk_groups_actors"

    create_table "permissions", :force => true do |t|
      t.string   "action"
      t.string   "object"
      t.string   "parameter"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "posts", :force => true do |t|
      t.integer  "activity_object_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "text"
    end

    add_index "posts", ["activity_object_id"], :name => "fk_post_object"

    create_table "relation_permissions", :force => true do |t|
      t.integer  "relation_id"
      t.integer  "permission_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "relation_id"
    end

    add_index "relation_permissions", ["relation_id"], :name => "fk_relation_permissions_relation"
    add_index "relation_permissions", ["permission_id"], :name => "fk_relation_permissions_permission"

    create_table "relations", :force => true do |t|
      t.string   "name",       :limit => 45
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "sender_type"
      t.string   "receiver_type"
      t.string   "ancestry"
      t.integer  "inverse_id"
      t.integer  "granted_id"
      t.boolean  "reflexive", :default => false
    end

    add_index "relations", ["ancestry"]

    create_table "tags", :force => true do |t|
      t.string   "name",       :limit => 45
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "tags_activity_objects", :force => true do |t|
      t.integer "tag_id"
      t.integer "activity_object_id"
    end

    add_index "tags_activity_objects", ["activity_object_id"], :name => "fk_tags_activity_objects_2"
    add_index "tags_activity_objects", ["tag_id"], :name => "fk_tags_activity_objects_1"

    create_table "ties", :force => true do |t|
      t.integer  "sender_id"
      t.integer  "receiver_id"
      t.integer  "relation_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "message"
    end

    add_index "ties", ["receiver_id"], :name => "fk_tie_receiver"
    add_index "ties", ["relation_id"], :name => "fk_tie_relation"
    add_index "ties", ["sender_id"], :name => "fk_tie_sender"

    create_table "users", :force => true do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable

      t.timestamps
      t.integer  "actor_id"
    end

    add_index "users", ["actor_id"], :name => "fk_users_actors"
    add_index "users", :reset_password_token, :unique => true
    # add_index :users, :confirmation_token, :unique => true
    # add_index :users, :unlock_token,       :unique => true
  end

  def self.down
    drop_table :activities
    drop_table :activity_object_activities
    drop_table :activity_objects
    drop_table :activity_verbs
    drop_table :actors
    drop_table :comments
    drop_table :group
    drop_table :permissions
    drop_table :posts
    drop_table :_relation_permissions
    drop_table :relations
    drop_table :tags
    drop_table :tags_activity_objects
    drop_table :ties
    drop_table :users
  end
end
