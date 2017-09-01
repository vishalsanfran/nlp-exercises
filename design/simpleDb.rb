class SimpleDb
  attr_accessor :d, :txs
  def initialize
    @d = {}
    @txs = []
  end
  def set(key, val)
    if @txs.length == 0
      @d[key] = val
    else
      @txs[-1][key] = val
    end
  end
  def get(key)
    @txs.reverse.each do |tx|
      if tx.include? key
        return tx[key]
      end
    end
    @d[key]
  end
  def unset(key)
    if @txs.length == 0
      @d.delete(key)
    else
      @txs[-1][key] = nil
    end
  end
  def rollback
    @txs.pop
  end
  def begin
    @txs.push({})
  end
  def commit
    @txs.each do |tx|
      tx.each do |key, val|
        if val == nil
          @d.delete(key)
        else
          @d[key] = val
        end
      end
    end
    @txs = []
  end
end

db = SimpleDb.new
db.set('name','vishal')
db.set('age', 33)
db.begin
db.set('addr', 'sunnyvale')
db.unset('age')
db.begin
db.set('gender', 'm')
db.rollback
db.rollback
db.commit
puts db.d, db.txs.inspect
