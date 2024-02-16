import Pkg; Pkg.activate(".")

using ZipFile
using PDBTools
using DelimitedFiles
using MolSimToolkit

function cover_art()

projection_coordinates = readdlm("./fig4/projection.dat")
helical_content = readdlm("../SecondaryStructure/helix_tot.txt")
qf = readdlm("./fig4/q_f.dat")
pdb_dir = "../SecondaryStructure/equilibrated_all_atom_models/"
pdb_files = sort!(
    filter(file -> occursin("pdb", file), readdir(pdb_dir));
    by = file -> parse(Int, first(split(file,'.'))), 
)

xextrema = extrema(projection_coordinates[:,1])
yextrema = extrema(projection_coordinates[:,2])

# Scale positions between 1 and 1000
projection_coordinates[:,1] .= 900 .* (projection_coordinates[:,1] .- xextrema[1]) ./ (xextrema[2] - xextrema[1])
projection_coordinates[:,2] .= 900 .* (projection_coordinates[:,2] .- yextrema[1]) ./ (yextrema[2] - yextrema[1])

inds = 1:length(pdb_files)
x = projection_coordinates[inds, 1]
y = projection_coordinates[inds, 2]

zextrema = extrema(qf)
z = 900 .* (qf[:,1] .- zextrema[1]) ./ (zextrema[2] - zextrema[1])

hextrema = extrema(helical_content)
hc = (helical_content[:,1] .- hextrema[1]) ./ (hextrema[2] - hextrema[1])

Base.rm("all.pdb", force=true)
for (i, ifile) in enumerate(inds)
    file = pdb_files[ifile]
    atoms = try
        zip = ZipFile.Reader(pdb_dir*file)
        readPDB(IOBuffer(read(zip.files[1],String)))
    catch
        println("error on file $i")
        continue
    end
    cm = center_of_mass(coor(atoms), mass.(atoms))
    for (iat, atom) in enumerate(atoms)
        atom.x = atom.x - cm[1] + x[i]
        atom.y = atom.y - cm[2] + y[i]
        atom.z = atom.z - cm[3] + z[i]
        if resnum(atom) == 1
            atom.beta = 0.0
        elseif resnum(atom) == 2
            atom.beta == 1.0
        else
            atom.beta = hc[i]
        end
    end
    writePDB(atoms, "test.pdb")
    open("all.pdb", "a") do io
        Base.run(pipeline(`cat test.pdb`, stdout=io))
    end
end

end # run
