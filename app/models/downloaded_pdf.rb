class DownloadedPdf < ApplicationRecord
    belongs_to :pdf
    belongs_to :user
end