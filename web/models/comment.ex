defmodule FredIt.Comment do
  use FredIt.Web, :model

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
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:content, max: 100)
  end

@doc """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :content])
    |> validate_required([:name, :content])
  end
  """

end
