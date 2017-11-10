defmodule FredIt.Comment do
  use FredIt.Web, :model

  require IEx

  schema "comments" do
    field :name, :string
    field :content, :string
    belongs_to :post, FredIt.Post,  foreign_key: :post_id

    timestamps()
  end

  @required_fields ~w(name content post_id)
  @optional_fields ~w()



  @doc """
  Creates a changeset based on the `model` and `params`.
  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    IEx.pry

    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:content, max: 140)
  end


end
