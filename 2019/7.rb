require_relative 'util'
lines = $<.read.split("\n")

og = lines[0].split(',').map(&:to_i)
max = 0

(5..9).to_a.permutation do |phases|
  p phases
  softwares =
    5.times.map do
      # code   ps halted read  output
      [og.dup, 0, false, true, nil]
    end

  phases.cycle.with_index do |phase, idx|
    break if softwares.all? { |s| s[2] }

    idx %= 5
    software = softwares[idx]

    next if software[2]
    a = software[0]
    ps = software[1]
    last_output = softwares[idx - 1][4] || 0
    done = false

    until software[2] || done
      #modea=a[ps]/10000
      modeb = (a[ps] % 10_000) / 1000
      modec = (a[ps] % 1000) / 100
      case a[ps] % 100
      when 1
        a[a[ps + 3]] =
          (modec == 1 ? a[ps + 1] : a[a[ps + 1]]) +
            (modeb == 1 ? a[ps + 2] : a[a[ps + 2]])
        ps += 4
      when 2
        a[a[ps + 3]] =
          (modec == 1 ? a[ps + 1] : a[a[ps + 1]]) *
            (modeb == 1 ? a[ps + 2] : a[a[ps + 2]])
        ps += 4
      when 3
        a[a[ps + 1]] = software[3] ? phase : last_output
        software[3] = false
        ps += 2
      when 4
        output = a[a[ps + 1]]
        software[4] = output
        ps += 2
        done = true
      when 5
        if ((modec == 1 ? a[ps + 1] : a[a[ps + 1]]) != 0)
          (ps = (modeb == 1 ? a[ps + 2] : a[a[ps + 2]]))
        else
          ps += 3
        end
      when 6
        if ((modec == 1 ? a[ps + 1] : a[a[ps + 1]]) == 0)
          (ps = (modeb == 1 ? a[ps + 2] : a[a[ps + 2]]))
        else
          ps += 3
        end
      when 7
        a[a[ps + 3]] =
          if (modec == 1 ? a[ps + 1] : a[a[ps + 1]]) <
               (modeb == 1 ? a[ps + 2] : a[a[ps + 2]])
            1
          else
            0
          end
        ps += 4
      when 8
        a[a[ps + 3]] =
          if (modec == 1 ? a[ps + 1] : a[a[ps + 1]]) ==
               (modeb == 1 ? a[ps + 2] : a[a[ps + 2]])
            1
          else
            0
          end
        ps += 4
      when 99
        software[2] = true
        break
      else
        raise '??'
      end
    end

    software[0] = a
    software[1] = ps
  end

  p softwares.last[4]
  max = [softwares.last[4], max].max
end

p max
