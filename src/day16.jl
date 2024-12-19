using Graphs, DataStructures, SparseArrays, Memoization

const DIR = "aoc_2024"

@memoize function dfs16(vtx, set, arr)
    a = arr[vtx]
    for p in a
        push!(set, p ÷ 5)
        dfs16(p, set, arr)
    end
end

function day16()
    part = [0, 0]
    start_dir = 2 # set this way by problem text to be East
    stop_dir = 2 # determined by exam of data file to be East

    mat = stack([collect(line) for line in readlines("$DIR/day16.txt")], dims = 1)
    rows, cols = size(mat)
    directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
    scalar(c, d) = Int32(((c[1] - 1) * cols + c[2]) * 5 + d)
    descale(x) = [(x ÷ 5) ÷ cols, (x ÷ 5) % cols]
    start_c = findfirst(c -> mat[c] == 'S', CartesianIndices(mat))
    start_vertex = scalar(start_c, start_dir)
    stop_c = findfirst(c -> mat[c] == 'E', CartesianIndices(mat))
    stop_vertex = scalar(stop_c, stop_dir)
    distmx = spzeros(Int32, rows * cols * 5 + 4, rows * cols * 5 + 4)

    g = SimpleGraph{Int32}(rows * cols * 10)
    d_mat(v1, v2) = abs(v1 - v2) > 4 ? 1 : 1000
    for c in CartesianIndices(mat)
        mat[c] == '#' && continue
        for start_d in 1:4
            for turn_d in 1:4
                start_d == turn_d && continue
                abs(start_d - turn_d) == 2 && continue  # no 180 turns
                v1, v2 = scalar(c, start_d), scalar(c, turn_d)
                add_edge!(g, v1, v2)
                distmx[v1, v2] = 1000
                distmx[v2, v1] = 1000
            end
            adj = Tuple(c) .+ directions[start_d]
            if 1 <= adj[1] <= rows && 1 <= adj[2] <= cols && mat[adj[1], adj[2]] != '#'
                v1, v2 = scalar(c, start_d), scalar(adj, start_d)
                add_edge!(g, v1, v2)
                distmx[v1, v2] = 1
                distmx[v2, v1] = 1
            end
        end
    end
    distmx = transpose(sparse(transpose(distmx)))

    state = dijkstra_shortest_paths(g, [start_vertex], distmx, maxdist = 150000, allpaths = true)
    part[1] = state.dists[stop_vertex]

    all_path_tiles = Set{Int}()
    dfs16(stop_vertex, all_path_tiles, state.predecessors)
    part[2] = length(all_path_tiles) + 1

    return part
end

@show day16() # [106512, 563]
