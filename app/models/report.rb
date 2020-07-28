class Report < ApplicationRecord
  belongs_to :organization

  paginates_per 20

  enum state: { enqueued: 0, processing: 1, finished: 2, errored: 3 } do
    event :process do
      transition enqueued: :processing
    end

    event :finish do
      transition processing: :finished
    end

    event :break do
      transition all => :errored
    end
  end
end
