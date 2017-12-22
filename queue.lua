queue = {}
function queue.new ()
    return {first = 0, last = -1}
end
function queue.size(q)
	return q.last-q.first+1
end
function queue.add_tail (q, v)
    local last = q.last + 1
    q.last = last
    q[last] = v
end
function queue.get_head (q)
    local first = q.first
    if first > q.last then 
        return nil
    else 
        local v = q[first]
        q[first] = nil
        q.first = first + 1
        return v
    end
end
