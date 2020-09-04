if FORMAT:match 'markdown' then

  function Image(elem)
    -- Make sure extension is .png
    elem.src = elem.src:gsub("%.pdf", ".png")

    -- Prepend figure directory
    elem.src = "figs/" .. elem.src
    return elem
  end

end