require_relative '../spec_helper'

describe AbstractWriter do
  context 'init' do
    it 'should follow this contract' do
      w = AbstractWriter.new
      # expect {w.write_new_row}.to raise_error(NotImplementedError, /implemented interface method: 'write_new_row'/)
      expect {w.write_new_row}.to raise_error(NotImplementedError, "implemented interface method: 'write_new_row'")
    end

  end
end