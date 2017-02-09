class Array
  def real_intersection(arr2)
    self_sorted = self.sort
    target_sorted = arr2.sort
    intersection= []
    jstart=0
    for i in (0..self_sorted.length-1)
      for j in (jstart..target_sorted.length-1)
        if self_sorted[i] == target_sorted[j]
          jstart = j+1
          intersection[intersection.length] = self_sorted[i]
          break
        end
      end
    end
    return intersection
  end
end
