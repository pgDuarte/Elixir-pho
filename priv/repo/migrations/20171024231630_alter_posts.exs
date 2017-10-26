defmodule FredIt.Repo.Migrations.AlterPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
        add :userId, :string
      end
  end
end
