#different views can share in the helper code.
module ApplicationHelper
  #takes data from the database table RVP, gets all the records or rows from the table, and then it returns all the records as a list or collection.
  def fetch_all_rvps
    Rvp.all
  end
end