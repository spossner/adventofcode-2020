# Definition for single-linked list.
class ListNode
    attr_accessor :val, :next

    def initialize(val)
        @val = val
        @next = nil
    end

    def add(n)
        if @next
            @next.add n
        else
            new_node = ListNode.new n
            @next = new_node
        end
    end

    def to_s
        "#{@val}" + (@next ? " -> #{@next}" : "")
    end

    def ListNode.from_array(arr)
        head = nil
        tail = nil
        arr.each do |e|
            node = ListNode.new(e)
            if tail == nil
                head = tail = node
            else
                tail.next = node
            end
            tail = node
        end
        return head
    end
end

