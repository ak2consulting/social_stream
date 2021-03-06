require 'active_support/concern'

module SocialStream
  module Models
    # Additional features for models that are subtypes of actors
    module Actor
      extend ActiveSupport::Concern

      included do
        belongs_to :actor,
                   :validate => true,
                   :autosave => true

        delegate :name, :name=,
                 :email, :email=,
                 :permalink,
                 :logo,
                 :ties, :sent_ties, :received_ties,
                 :active_ties_to,
                 :pending_ties,
                 :sender_subjects, :receiver_subjects,
                 :suggestions, :suggestion,
                 :wall, :wall_profile,
                 :to => :actor!


        validates_presence_of :name

        scope :alphabetic, includes(:actor).order('actors.name')

        scope :with_sent_ties,     joins(:actor => :sent_ties)
        scope :with_received_ties, joins(:actor => :received_ties)

        after_create :initialize_reflexive_ties
      end

      module InstanceMethods
        def actor!
          actor || build_actor(:subject_type => self.class.to_s)
        end

        def to_param
          permalink
        end

        private

        def initialize_reflexive_ties
          self.class.relations.reflexive.each do |r|
            Tie.create! :sender => self.actor,
                        :receiver => self.actor,
                        :relation => r
          end
        end
      end

      module ClassMethods
        # Relations defined for this actor model.
        def relations(to = to_s)
          Relation.mode(to_s, to)
        end

        # Actor subtypes that may receive a tie from an instance of this class
        def receiving_subject_classes
          Relation.select("DISTINCT #{ Relation.quoted_table_name }.receiver_type").
            where(:sender_type => to_s).
            map(&:receiver_type).
            map(&:constantize)
        end

        def find_by_permalink(perm)
          joins(:actor).where('actors.permalink' => perm).first
        end

        def find_by_permalink!(perm)
          find_by_permalink(perm) ||
            raise(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
