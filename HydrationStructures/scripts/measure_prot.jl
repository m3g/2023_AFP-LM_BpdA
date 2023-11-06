function measure_prot(nome;dim=12)
  
  ## Variables - Measurement of the protein(X, Y and Z axis)
    pdbfile   = nome
    segment   = "all"
    restype   = "all"
    atomtype  = "all"
    firstatom = "all"
    lastatom  = "all"
  
  ## Open the file - 
    file    = open("$pdbfile","r+")
    natoms  = 0
    var     = 0
   
    for line in eachline(file)
  
      data = split(line)
      consider = false
      if data[1] == "ATOM" || data[1] == "HEATOM"
        natoms = natoms + 1
        ss = data[10]
        rt = data[4]
        at = data[3]
        consider = true
      else
        continue
      end  
  
      if firstatom != "all"
        if natoms < firstatom
          consider = false
        end
      end
  
      if lastatom != "all"    
        if natoms > lastatom  
          consider = false                                  
        end                    
      end                      
  
      if segment != "all"    
        if ss != segment  
          consider = false     
        end                    
      end                      
  
      if restype != "all"    
        if rt != restype  
          consider = false     
        end                    
      end                      
  
      if atomtype != "all"    
        if at != atomtype  
          consider = false     
        end                    
      end  
  
      if consider == true
        global x = parse(Float64,data[6])
        global y = parse(Float64,data[7])
        global z = parse(Float64,data[8])
      end
      
      if var == 1
        if x < xmin
            xmin = x
        end
        if y < ymin
            ymin = y
        end
        if z < zmin
            zmin = z
        end
        if x > xmax
            xmax = x
        end
        if y > ymax
            ymax = y
        end
        if z > zmax
            zmax = z
        end
      else
  
        global   xmin = x
        global   ymin = y
        global   zmin = z
        global   xmax = x
        global   ymax = y
        global   zmax = z
        var = 1
  
      end
  
    end
   
    ## Box size - add dim A in each size of box
    bx = round(Int,((xmax - xmin) + dim + dim)/2) 
    by = round(Int,((ymax - ymin) + dim + dim)/2)
    bz = round(Int,((zmax - zmin) + dim + dim)/2)
  
    return bx , by, bz
  
end
