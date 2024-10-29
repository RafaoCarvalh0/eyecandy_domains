defmodule EyecandyDomains do
  import Mogrify

  def run(w \\ 800, h \\ 800, g \\ 1) do
    # mca: main canvas attributes
    mca = %{w: w, h: h, margin: 30}

    %Mogrify.Image{path: "lib/square.jpg", ext: "jpg"}
    |> custom("size", "#{mca.w}x#{mca.h}")
    # Set the background color, e.g., "white"
    |> canvas("white")
    |> add_groups(mca, g)
    |> dbg()
  end

  def add_groups(image, mca, groups) do
    iterations = if groups == 1 do
      2
    else
      groups
    end

    add_new_group(image, mca, 1, iterations)
  end

  def add_new_group(image, _mca, div, max) when div >= max do
    create(image, in_place: true)
  end

  def add_new_group(image, mca, div, max) do
    dbg([mca, div, max])

    mca =
      if div != 1 do
        %{
          w: mca.w - 30,
          h: mca.h - 30,
          margin: mca.margin + 30
        }
      else
        mca
      end

    image
    # Make sure to only draw the outline, not fill it
    # Draw only the outline
    |> custom("fill", "none")
    # Set the outline color to black
    |> custom("stroke", "black")
    # Set the border thickness
    |> custom("strokewidth", "2")
    # Draw rectangle with margin from each side
    |> custom(
      "draw",
      "roundrectangle #{mca.margin},#{mca.margin} #{mca.w - mca.margin / div},#{mca.h - mca.margin / div} 2,2"
    )
    |> custom("gravity", "center")
    # Set the text color
    |> custom("fill", "black")
    # Set the text size
    |> custom("pointsize", "18")
    |> custom("font", "FreeMono")
    # Position text at the top center of the images
    |> custom("gravity", "north")
    # Offset text by 10 pixels down from the top
    |> custom("annotate", "+0+#{mca.margin - 20} contexts")
    |> format("jpg")
    |> add_new_group(mca, div + 1, max)
  end
end
