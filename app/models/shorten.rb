# == Schema Information
#
# Table name: shortens
#
#  id         :integer          not null, primary key
#  slug       :string(255)
#  url        :string(255)
#  visits     :integer
#  created_at :datetime
#  updated_at :datetime
#

class Shorten < ActiveRecord::Base
  before_validation :strip_url
  before_validation :set_slug

  validates :slug, presence: true, uniqueness: true
  validates :url, presence: true, url: { allow_blank: false, allow_nil: false }

  private

  def strip_url
    self.url.strip! if self.url.present?
  end

  def set_slug
    unless self.slug.present?
      self.slug = random_slug
    end
  end

  def random_slug
    generated_slug = SecureRandom.urlsafe_base64(3).rjust(5,'0')
    return generated_slug unless Shorten.find_by(slug: generated_slug)
    random_slug
  end
end
