class Report < ApplicationRecord
  belongs_to :organization

  enum state: { new: 0, enqued: 1, processing: 2, finished: 3, errored: 4 } do
    event :enqueue do
      transition new: :enqued
    end

    event :process do
      transition enqued: :processing
    end

    event :finish do
      transition processing: :finished
    end

    event :break do
      transition processing: :errored
    end
  end
end
