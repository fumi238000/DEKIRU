ActiveAdmin.register Contact do
  # N+1対策
  includes :user
end
