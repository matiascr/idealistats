defmodule Idealistats do
  opts = [
    country: [
      type: {:in, ~W(es it pt)},
      default: "es",
      doc: """
      The country of the search
      """
    ],
    operation: [
      type: {:in, ~W(sale rent)},
      default: "sale",
      doc: """
      The type of operation to perform
      """
    ],
    propertyType: [
      type: {:in, ~W(homes offices premises garages bedrooms)},
      default: "homes",
      doc: """
      The type of commodity to search
      """
    ],
    locationId: [
      type: :string,
      doc: """
      The area ID of the search:
      In `es`:
        0-EU-ES-1 to 0-EU-ES-56
      """
    ],
    numPage: [
      type: :integer,
      default: 0,
      doc: """
      The page number to retrieve
      """
    ],
    maxItems: [
      type: :pos_integer,
      default: 50
    ],
    order: [
      type:
        {:in, ~W(distance price street photos publicationDate modificationDate size floor rooms)},
      default: "publicationDate"
    ],
    sort: [
      type: {:in, ~W(asc desc)},
      default: "desc"
    ]
  ]

  @opts_schema NimbleOptions.new!(opts)

  @api_url "https://api.idealista.com/3.5/es/search"

  @unwanted [
    "thumbnail",
    "externalReference",
    "numPhotos",
    "has3DTour",
    "has360",
    "hasStaging",
    "floor",
    "hasPlan",
    "url",
    "description",
    "hasVideo",
    "showAddress",
    "propertyCode",
    "detailedType",
    "suggestedTexts",
    "status",
    "topNewDevelopment",
    "address",
    "country",
    "operation",
    "parkingSpace",
    "neighborhood",
    "hasLift",
    "district"
  ]

  @doc """
  Fetches a page of Idealista given the filters.

  ## Options

  #{NimbleOptions.docs(@opts_schema)}
  """
  @spec get_page(token :: String.t(), page :: integer(), opts :: map()) :: term() | no_return()
  def get_page(token, page, opts) do
    query = NimbleOptions.validate!(opts, @opts_schema) |> Keyword.put(:numPage, page)

    headers = [
      {"Authorization", "Bearer #{token}"},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]

    {:ok, res} = Tesla.post(@api_url, "", query: query, headers: headers)

    Jason.decode!(res.body)
  end
end
