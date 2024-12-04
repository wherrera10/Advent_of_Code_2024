using BenchmarkTools

const DIR = "aoc_2024"

function day04()
	part = [0, 0]
	mat = stack([collect(line) for line in readlines("$DIR/day04.txt")], dims = 1)
	nrows, ncols = size(mat)
	xmas = ['X', 'M', 'A', 'S']
    samx = ['S', 'A', 'M', 'X']
	for c in CartesianIndices(mat)
		c[2] < ncols - 2 && mat[c[1], c[2]:c[2]+3] == xmas && (part[1] += 1)
        c[2] > 3 && mat[c[1], c[2]-3:c[2]] == samx && (part[1] += 1)
        c[1] < nrows - 2 && mat[c[1]:c[1]+3, c[2]] == xmas && (part[1] += 1)
           c[1] > 3 && mat[c[1]-3:c[1], c[2]] == samx && (part[1] += 1)
		   c[1] < nrows - 2 && c[2] < ncols - 2 && [mat[c[1], c[2]], mat[c[1]+1, c[2]+1], mat[c[1]+2, c[2]+2], mat[c[1]+3, c[2]+3]] == xmas && (part[1] += 1)
		   c[1] > 3  && c[2] > 3 && [mat[c[1]-3, c[2]-3], mat[c[1]-2, c[2]-2], mat[c[1]-1, c[2]-1], mat[c[1], c[2]]] == samx && (part[1] += 1)
		   c[1] > 3 && c[2] < ncols - 2 && [mat[c[1], c[2]], mat[c[1]-1, c[2]+1], mat[c[1]-2, c[2]+2], mat[c[1]-3, c[2]+3]] == xmas && (part[1] += 1)
		   c[1] < nrows - 2 && c[2] > 3 && [mat[c[1]+3, c[2]-3], mat[c[1]+2, c[2]-2], mat[c[1]+1, c[2]-1], mat[c[1], c[2]]] == samx && (part[1] += 1)
	end


    for c in CartesianIndices(mat)
        if mat[c] != 'A' || c[1] == 1 || c[1] == nrows || c[2] == 1 || c[2] == ncols
            continue
        end
        mat[c[1] - 1, c[2] - 1] == 'M' && mat[c[1] - 1, c[2] + 1] == 'M' && mat[c[1] + 1, c[2] - 1] == 'S' && mat[c[1] + 1, c[2] + 1] == 'S' && (part[2] += 1)
        mat[c[1] - 1, c[2] - 1] == 'M' && mat[c[1] - 1, c[2] + 1] == 'S' && mat[c[1] + 1, c[2] - 1] == 'M' && mat[c[1] + 1, c[2] + 1] == 'S' && (part[2] += 1)
        mat[c[1] - 1, c[2] - 1] == 'S' && mat[c[1] - 1, c[2] + 1] == 'S' && mat[c[1] + 1, c[2] - 1] == 'M' && mat[c[1] + 1, c[2] + 1] == 'M' && (part[2] += 1)
        mat[c[1] - 1, c[2] - 1] == 'S' && mat[c[1] - 1, c[2] + 1] == 'M' && mat[c[1] + 1, c[2] - 1] == 'S' && mat[c[1] + 1, c[2] + 1] == 'M' && (part[2] += 1)
    end
	return part
end

@show day01()
