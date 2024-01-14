defmodule Idealistats do
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

  def get_page(
        token,
        index \\ 1,
        location_id \\ "0-EU-ES-28",
        country \\ "es",
        operation \\ "sale",
        propertyType \\ "homes"
      ) do
    headers = [
      {"Authorization", "Bearer #{token}"},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]

    query = [
      # es, it, pt
      country: country,
      # sale, rent
      operation: operation,
      # homes, offices, premises, garages, bedrooms
      propertyType: propertyType,
      # 0-EU-ES-1 to 0-EU-ES-56
      locationId: location_id,
      numPage: index,
      # max 50
      maxItems: "50",
      # distance, price, street, photos, publicationDate, modificationDate, size, floor, rooms
      order: "publicationDate",
      # desc, asc
      sort: "desc"
    ]

    {:ok, %{body: body}} =
      Tesla.post(@api_url, "", query: query, headers: headers)

    Jason.decode!(body)
  end

  def get_all_pages(token, location_id \\ "0-EU-ES-28") do
    first = get_page(token, 1, location_id)

    total_pages = first |> Map.get("totalPages")
    IO.puts("From #{Integer.to_string(total_pages)} pages")
    first_page = first |> Map.get("elementList")

    [
      first_page
      | Enum.map(2..total_pages, fn x ->
          page = get_page(token, x, location_id)
          # :timer.sleep(100)
          page
          |> Map.get("elementList")
        end)
    ]
    |> List.flatten()
  end

  def to_dataframe(json) do
    json
    |> Enum.map(fn x ->
      Enum.filter(x, fn {y, _} -> not Enum.member?(@unwanted, y) end) |> Enum.into(%{})
    end)

    # |> Explorer.DataFrame.new()
  end
end
