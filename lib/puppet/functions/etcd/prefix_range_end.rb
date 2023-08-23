# frozen_string_literal: true

# @summary
#   Calculates the range-end for a given prefix.
#   Can be used for the `range_end` parameter of `etcd_role_permission`, to grant prefix.
Puppet::Functions.create_function(:'etcd::prefix_range_end') do
  # @param prefix
  #   The prefix key to calculate the range-end for
  #
  # @return
  #   The range-end for the given prefix.
  dispatch :prefix_range_end do
    param 'String', :prefix
  end

  def prefix_range_end(prefix)
    prefix_bytes = prefix.bytes
    range_end = prefix_bytes.dup
    (range_end.length - 1).downto(0) do |i|
      next unless range_end[i] < 0xff
      range_end[i] += 1
      range_end = range_end[0..i]
      return range_end.pack('c*')
    end
  end
end
