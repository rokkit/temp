
# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 0) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "_accumrg1513", id: false, force: :cascade do |t|
    t.datetime "_period",                                 null: false
    t.binary   "_recordertref",                           null: false
    t.binary   "_recorderrref",                           null: false
    t.decimal  "_lineno",        precision: 9,            null: false
    t.boolean  "_active",                                 null: false
    t.decimal  "_recordkind",    precision: 1,            null: false
    t.binary   "_fld1514rref",                            null: false
    t.binary   "_fld1515rref",                            null: false
    t.binary   "_fld1516_type",                           null: false
    t.binary   "_fld1516_rtref",                          null: false
    t.binary   "_fld1516_rrref",                          null: false
    t.decimal  "_fld1517",       precision: 15, scale: 2, null: false
  end

  add_index "_accumrg1513", ["_fld1514rref", "_period", "_recordertref", "_recorderrref", "_lineno"], name: "_accumr1513_bydims1518_rtrn", unique: true, using: :btree
  add_index "_accumrg1513", ["_fld1515rref", "_period", "_recordertref", "_recorderrref", "_lineno"], name: "_accumr1513_bydims1519_rtrn", unique: true, using: :btree
  add_index "_accumrg1513", ["_period", "_recordertref", "_recorderrref", "_lineno"], name: "_accumr1513_byperiod_trn", unique: true, using: :btree
  add_index "_accumrg1513", ["_recordertref", "_recorderrref", "_lineno"], name: "_accumr1513_byrecorder_rn", unique: true, using: :btree

  create_table "_accumrg1522", id: false, force: :cascade do |t|
    t.datetime "_period",                                null: false
    t.binary   "_recordertref",                          null: false
    t.binary   "_recorderrref",                          null: false
    t.decimal  "_lineno",       precision: 9,            null: false
    t.boolean  "_active",                                null: false
    t.decimal  "_recordkind",   precision: 1,            null: false
    t.binary   "_fld1523rref",                           null: false
    t.binary   "_fld1524rref",                           null: false
    t.decimal  "_fld1525",      precision: 15, scale: 2, null: false
  end

  add_index "_accumrg1522", ["_period", "_recordertref", "_recorderrref", "_lineno"], name: "_accumr1522_byperiod_trn", unique: true, using: :btree
  add_index "_accumrg1522", ["_recordertref", "_recorderrref", "_lineno"], name: "_accumr1522_byrecorder_rn", unique: true, using: :btree

  create_table "_accumrg1528", id: false, force: :cascade do |t|
    t.datetime "_period",                                null: false
    t.binary   "_recordertref",                          null: false
    t.binary   "_recorderrref",                          null: false
    t.decimal  "_lineno",       precision: 9,            null: false
    t.boolean  "_active",                                null: false
    t.decimal  "_recordkind",   precision: 1,            null: false
    t.binary   "_fld1529rref",                           null: false
    t.decimal  "_fld1530",      precision: 15, scale: 2, null: false
  end

  add_index "_accumrg1528", ["_period", "_recordertref", "_recorderrref", "_lineno"], name: "_accumr1528_byperiod_trn", unique: true, using: :btree
  add_index "_accumrg1528", ["_recordertref", "_recorderrref", "_lineno"], name: "_accumr1528_byrecorder_rn", unique: true, using: :btree

  create_table "_accumrg1557", id: false, force: :cascade do |t|
    t.datetime "_period",                                null: false
    t.binary   "_recordertref",                          null: false
    t.binary   "_recorderrref",                          null: false
    t.decimal  "_lineno",       precision: 9,            null: false
    t.boolean  "_active",                                null: false
    t.decimal  "_recordkind",   precision: 1,            null: false
    t.binary   "_fld1558rref",                           null: false
    t.binary   "_fld1559rref",                           null: false
    t.binary   "_fld1560rref",                           null: false
    t.binary   "_fld1561rref",                           null: false
    t.decimal  "_fld1562",      precision: 15, scale: 2, null: false
    t.decimal  "_fld1563",      precision: 15, scale: 3, null: false
    t.decimal  "_fld1564",      precision: 15, scale: 2, null: false
  end

  add_index "_accumrg1557", ["_fld1559rref", "_period", "_recordertref", "_recorderrref", "_lineno"], name: "_accumr1557_bydims1565_rtrn", unique: true, using: :btree
  add_index "_accumrg1557", ["_period", "_recordertref", "_recorderrref", "_lineno"], name: "_accumr1557_byperiod_trn", unique: true, using: :btree
  add_index "_accumrg1557", ["_recordertref", "_recorderrref", "_lineno"], name: "_accumr1557_byrecorder_rn", unique: true, using: :btree

  create_table "_accumrg1568", id: false, force: :cascade do |t|
    t.datetime "_period",                                null: false
    t.binary   "_recordertref",                          null: false
    t.binary   "_recorderrref",                          null: false
    t.decimal  "_lineno",       precision: 9,            null: false
    t.boolean  "_active",                                null: false
    t.binary   "_fld1569rref",                           null: false
    t.binary   "_fld1570rref",                           null: false
    t.binary   "_fld1571rref",                           null: false
    t.binary   "_fld1572rref",                           null: false
    t.decimal  "_fld1573",      precision: 15, scale: 3, null: false
    t.decimal  "_fld1574",      precision: 15, scale: 2, null: false
    t.decimal  "_fld1575",      precision: 15, scale: 2, null: false
  end

  add_index "_accumrg1568", ["_fld1572rref", "_period", "_recordertref", "_recorderrref", "_lineno"], name: "_accumr1568_bydims1576_rtrn", unique: true, using: :btree
  add_index "_accumrg1568", ["_period", "_recordertref", "_recorderrref", "_lineno"], name: "_accumr1568_byperiod_trn", unique: true, using: :btree
  add_index "_accumrg1568", ["_recordertref", "_recorderrref", "_lineno"], name: "_accumr1568_byrecorder_rn", unique: true, using: :btree

  create_table "_accumrg1579", id: false, force: :cascade do |t|
    t.datetime "_period",                                 null: false
    t.binary   "_recordertref",                           null: false
    t.binary   "_recorderrref",                           null: false
    t.decimal  "_lineno",        precision: 9,            null: false
    t.boolean  "_active",                                 null: false
    t.decimal  "_recordkind",    precision: 1,            null: false
    t.binary   "_fld1580rref",                            null: false
    t.binary   "_fld1581rref",                            null: false
    t.binary   "_fld1582_type",                           null: false
    t.binary   "_fld1582_rtref",                          null: false
    t.binary   "_fld1582_rrref",                          null: false
    t.decimal  "_fld1583",       precision: 15, scale: 6, null: false
    t.decimal  "_fld1584",       precision: 15, scale: 3, null: false
    t.binary   "_fld1585rref",                            null: false
  end

  add_index "_accumrg1579", ["_period", "_recordertref", "_recorderrref", "_lineno"], name: "_accumr1579_byperiod_trn", unique: true, using: :btree
  add_index "_accumrg1579", ["_recordertref", "_recorderrref", "_lineno"], name: "_accumr1579_byrecorder_rn", unique: true, using: :btree

  create_table "_accumrg1588", id: false, force: :cascade do |t|
    t.datetime "_period",                                null: false
    t.binary   "_recordertref",                          null: false
    t.binary   "_recorderrref",                          null: false
    t.decimal  "_lineno",       precision: 9,            null: false
    t.boolean  "_active",                                null: false
    t.binary   "_fld1589rref",                           null: false
    t.binary   "_fld1590rref",                           null: false
    t.binary   "_fld1591rref",                           null: false
    t.binary   "_fld1592rref",                           null: false
    t.decimal  "_fld1593",      precision: 15, scale: 3, null: false
    t.decimal  "_fld1594",      precision: 15, scale: 2, null: false
  end

  add_index "_accumrg1588", ["_period", "_recordertref", "_recorderrref", "_lineno"], name: "_accumr1588_byperiod_trn", unique: true, using: :btree
  add_index "_accumrg1588", ["_recordertref", "_recorderrref", "_lineno"], name: "_accumr1588_byrecorder_rn", unique: true, using: :btree

  create_table "_accumrg1597", id: false, force: :cascade do |t|
    t.datetime "_period",                                null: false
    t.binary   "_recordertref",                          null: false
    t.binary   "_recorderrref",                          null: false
    t.decimal  "_lineno",       precision: 9,            null: false
    t.boolean  "_active",                                null: false
    t.binary   "_fld1598rref",                           null: false
    t.binary   "_fld1599rref",                           null: false
    t.binary   "_fld1600rref",                           null: false
    t.decimal  "_fld1601",      precision: 15, scale: 3, null: false
    t.decimal  "_fld1602",      precision: 15, scale: 2, null: false
  end

  add_index "_accumrg1597", ["_period", "_recordertref", "_recorderrref", "_lineno"], name: "_accumr1597_byperiod_trn", unique: true, using: :btree
  add_index "_accumrg1597", ["_recordertref", "_recorderrref", "_lineno"], name: "_accumr1597_byrecorder_rn", unique: true, using: :btree

  create_table "_accumrg1605", id: false, force: :cascade do |t|
    t.datetime "_period",                                null: false
    t.binary   "_recordertref",                          null: false
    t.binary   "_recorderrref",                          null: false
    t.decimal  "_lineno",       precision: 9,            null: false
    t.boolean  "_active",                                null: false
    t.decimal  "_recordkind",   precision: 1,            null: false
    t.binary   "_fld1606rref",                           null: false
    t.decimal  "_fld1607",      precision: 15, scale: 2, null: false
  end

  add_index "_accumrg1605", ["_period", "_recordertref", "_recorderrref", "_lineno"], name: "_accumr1605_byperiod_trn", unique: true, using: :btree
  add_index "_accumrg1605", ["_recordertref", "_recorderrref", "_lineno"], name: "_accumr1605_byrecorder_rn", unique: true, using: :btree

  create_table "_accumrg1610", id: false, force: :cascade do |t|
    t.datetime "_period",                                null: false
    t.binary   "_recordertref",                          null: false
    t.binary   "_recorderrref",                          null: false
    t.decimal  "_lineno",       precision: 9,            null: false
    t.boolean  "_active",                                null: false
    t.decimal  "_recordkind",   precision: 1,            null: false
    t.binary   "_fld1611rref",                           null: false
    t.binary   "_fld1612rref",                           null: false
    t.binary   "_fld1613rref",                           null: false
    t.binary   "_fld1614rref",                           null: false
    t.binary   "_fld1615rref",                           null: false
    t.decimal  "_fld1616",      precision: 12, scale: 3, null: false
    t.decimal  "_fld1617",      precision: 13, scale: 2, null: false
  end

  add_index "_accumrg1610", ["_period", "_recordertref", "_recorderrref", "_lineno"], name: "_accumr1610_byperiod_trn", unique: true, using: :btree
  add_index "_accumrg1610", ["_recordertref", "_recorderrref", "_lineno"], name: "_accumr1610_byrecorder_rn", unique: true, using: :btree

  create_table "_accumrg1620", id: false, force: :cascade do |t|
    t.datetime "_period",                      null: false
    t.binary   "_recordertref",                null: false
    t.binary   "_recorderrref",                null: false
    t.decimal  "_lineno",       precision: 9,  null: false
    t.boolean  "_active",                      null: false
    t.binary   "_fld1621rref",                 null: false
    t.decimal  "_fld1622",      precision: 15, null: false
  end

  add_index "_accumrg1620", ["_period", "_recordertref", "_recorderrref", "_lineno"], name: "_accumr1620_byperiod_trn", unique: true, using: :btree
  add_index "_accumrg1620", ["_recordertref", "_recorderrref", "_lineno"], name: "_accumr1620_byrecorder_rn", unique: true, using: :btree

  create_table "_accumrg1625", id: false, force: :cascade do |t|
    t.datetime "_period",                                null: false
    t.binary   "_recordertref",                          null: false
    t.binary   "_recorderrref",                          null: false
    t.decimal  "_lineno",       precision: 9,            null: false
    t.boolean  "_active",                                null: false
    t.binary   "_fld1626rref",                           null: false
    t.decimal  "_fld1627",      precision: 15, scale: 2, null: false
  end

  add_index "_accumrg1625", ["_period", "_recordertref", "_recorderrref", "_lineno"], name: "_accumr1625_byperiod_trn", unique: true, using: :btree
  add_index "_accumrg1625", ["_recordertref", "_recorderrref", "_lineno"], name: "_accumr1625_byrecorder_rn", unique: true, using: :btree

  create_table "_accumrgchngr1521", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                    null: false
    t.binary  "_noderref",                    null: false
    t.decimal "_messageno",    precision: 10
    t.binary  "_recordertref",                null: false
    t.binary  "_recorderrref",                null: false
  end

  add_index "_accumrgchngr1521", ["_nodetref", "_noderref", "_messageno", "_recordertref", "_recorderrref"], name: "_accumr1521_bynodemsg_rnr", unique: true, using: :btree
  add_index "_accumrgchngr1521", ["_recordertref", "_recorderrref", "_nodetref", "_noderref"], name: "_accumr1521_bydatakey_rr", unique: true, using: :btree

  create_table "_accumrgchngr1527", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                    null: false
    t.binary  "_noderref",                    null: false
    t.decimal "_messageno",    precision: 10
    t.binary  "_recordertref",                null: false
    t.binary  "_recorderrref",                null: false
  end

  add_index "_accumrgchngr1527", ["_nodetref", "_noderref", "_messageno", "_recordertref", "_recorderrref"], name: "_accumr1527_bynodemsg_rnr", unique: true, using: :btree
  add_index "_accumrgchngr1527", ["_recordertref", "_recorderrref", "_nodetref", "_noderref"], name: "_accumr1527_bydatakey_rr", unique: true, using: :btree

  create_table "_accumrgchngr1532", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                    null: false
    t.binary  "_noderref",                    null: false
    t.decimal "_messageno",    precision: 10
    t.binary  "_recordertref",                null: false
    t.binary  "_recorderrref",                null: false
  end

  add_index "_accumrgchngr1532", ["_nodetref", "_noderref", "_messageno", "_recordertref", "_recorderrref"], name: "_accumr1532_bynodemsg_rnr", unique: true, using: :btree
  add_index "_accumrgchngr1532", ["_recordertref", "_recorderrref", "_nodetref", "_noderref"], name: "_accumr1532_bydatakey_rr", unique: true, using: :btree

  create_table "_accumrgchngr1556", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                    null: false
    t.binary  "_noderref",                    null: false
    t.decimal "_messageno",    precision: 10
    t.binary  "_recordertref",                null: false
    t.binary  "_recorderrref",                null: false
  end

  add_index "_accumrgchngr1556", ["_nodetref", "_noderref", "_messageno", "_recordertref", "_recorderrref"], name: "_accumr1556_bynodemsg_rnr", unique: true, using: :btree
  add_index "_accumrgchngr1556", ["_recordertref", "_recorderrref", "_nodetref", "_noderref"], name: "_accumr1556_bydatakey_rr", unique: true, using: :btree

  create_table "_accumrgchngr1567", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                    null: false
    t.binary  "_noderref",                    null: false
    t.decimal "_messageno",    precision: 10
    t.binary  "_recordertref",                null: false
    t.binary  "_recorderrref",                null: false
  end

  add_index "_accumrgchngr1567", ["_nodetref", "_noderref", "_messageno", "_recordertref", "_recorderrref"], name: "_accumr1567_bynodemsg_rnr", unique: true, using: :btree
  add_index "_accumrgchngr1567", ["_recordertref", "_recorderrref", "_nodetref", "_noderref"], name: "_accumr1567_bydatakey_rr", unique: true, using: :btree

  create_table "_accumrgchngr1578", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                    null: false
    t.binary  "_noderref",                    null: false
    t.decimal "_messageno",    precision: 10
    t.binary  "_recordertref",                null: false
    t.binary  "_recorderrref",                null: false
  end

  add_index "_accumrgchngr1578", ["_nodetref", "_noderref", "_messageno", "_recordertref", "_recorderrref"], name: "_accumr1578_bynodemsg_rnr", unique: true, using: :btree
  add_index "_accumrgchngr1578", ["_recordertref", "_recorderrref", "_nodetref", "_noderref"], name: "_accumr1578_bydatakey_rr", unique: true, using: :btree

  create_table "_accumrgchngr1587", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                    null: false
    t.binary  "_noderref",                    null: false
    t.decimal "_messageno",    precision: 10
    t.binary  "_recordertref",                null: false
    t.binary  "_recorderrref",                null: false
  end

  add_index "_accumrgchngr1587", ["_nodetref", "_noderref", "_messageno", "_recordertref", "_recorderrref"], name: "_accumr1587_bynodemsg_rnr", unique: true, using: :btree
  add_index "_accumrgchngr1587", ["_recordertref", "_recorderrref", "_nodetref", "_noderref"], name: "_accumr1587_bydatakey_rr", unique: true, using: :btree

  create_table "_accumrgchngr1596", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                    null: false
    t.binary  "_noderref",                    null: false
    t.decimal "_messageno",    precision: 10
    t.binary  "_recordertref",                null: false
    t.binary  "_recorderrref",                null: false
  end

  add_index "_accumrgchngr1596", ["_nodetref", "_noderref", "_messageno", "_recordertref", "_recorderrref"], name: "_accumr1596_bynodemsg_rnr", unique: true, using: :btree
  add_index "_accumrgchngr1596", ["_recordertref", "_recorderrref", "_nodetref", "_noderref"], name: "_accumr1596_bydatakey_rr", unique: true, using: :btree

  create_table "_accumrgchngr1604", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                    null: false
    t.binary  "_noderref",                    null: false
    t.decimal "_messageno",    precision: 10
    t.binary  "_recordertref",                null: false
    t.binary  "_recorderrref",                null: false
  end

  add_index "_accumrgchngr1604", ["_nodetref", "_noderref", "_messageno", "_recordertref", "_recorderrref"], name: "_accumr1604_bynodemsg_rnr", unique: true, using: :btree
  add_index "_accumrgchngr1604", ["_recordertref", "_recorderrref", "_nodetref", "_noderref"], name: "_accumr1604_bydatakey_rr", unique: true, using: :btree

  create_table "_accumrgchngr1609", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                    null: false
    t.binary  "_noderref",                    null: false
    t.decimal "_messageno",    precision: 10
    t.binary  "_recordertref",                null: false
    t.binary  "_recorderrref",                null: false
  end

  add_index "_accumrgchngr1609", ["_nodetref", "_noderref", "_messageno", "_recordertref", "_recorderrref"], name: "_accumr1609_bynodemsg_rnr", unique: true, using: :btree
  add_index "_accumrgchngr1609", ["_recordertref", "_recorderrref", "_nodetref", "_noderref"], name: "_accumr1609_bydatakey_rr", unique: true, using: :btree

  create_table "_accumrgchngr1619", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                    null: false
    t.binary  "_noderref",                    null: false
    t.decimal "_messageno",    precision: 10
    t.binary  "_recordertref",                null: false
    t.binary  "_recorderrref",                null: false
  end

  add_index "_accumrgchngr1619", ["_nodetref", "_noderref", "_messageno", "_recordertref", "_recorderrref"], name: "_accumr1619_bynodemsg_rnr", unique: true, using: :btree
  add_index "_accumrgchngr1619", ["_recordertref", "_recorderrref", "_nodetref", "_noderref"], name: "_accumr1619_bydatakey_rr", unique: true, using: :btree

  create_table "_accumrgchngr1624", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                    null: false
    t.binary  "_noderref",                    null: false
    t.decimal "_messageno",    precision: 10
    t.binary  "_recordertref",                null: false
    t.binary  "_recorderrref",                null: false
  end

  add_index "_accumrgchngr1624", ["_nodetref", "_noderref", "_messageno", "_recordertref", "_recorderrref"], name: "_accumr1624_bynodemsg_rnr", unique: true, using: :btree
  add_index "_accumrgchngr1624", ["_recordertref", "_recorderrref", "_nodetref", "_noderref"], name: "_accumr1624_bydatakey_rr", unique: true, using: :btree

  create_table "_accumrgchngr1629", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                    null: false
    t.binary  "_noderref",                    null: false
    t.decimal "_messageno",    precision: 10
    t.binary  "_recordertref",                null: false
    t.binary  "_recorderrref",                null: false
  end

  add_index "_accumrgchngr1629", ["_nodetref", "_noderref", "_messageno", "_recordertref", "_recorderrref"], name: "_accumr1629_bynodemsg_rnr", unique: true, using: :btree
  add_index "_accumrgchngr1629", ["_recordertref", "_recorderrref", "_nodetref", "_noderref"], name: "_accumr1629_bydatakey_rr", unique: true, using: :btree

  create_table "_accumrgopt1630", id: false, force: :cascade do |t|
    t.binary   "_regid",                          null: false
    t.datetime "_period",                         null: false
    t.boolean  "_actualperiod",                   null: false
    t.decimal  "_periodicity",      precision: 2, null: false
    t.decimal  "_repetitionfactor", precision: 2, null: false
    t.decimal  "_usetotals",        precision: 1, null: false
    t.datetime "_minperiod",                      null: false
    t.boolean  "_usesplitter",                    null: false
  end

  add_index "_accumrgopt1630", ["_regid"], name: "_accumr1630_byregid_b", unique: true, using: :btree

  create_table "_accumrgopt1631", id: false, force: :cascade do |t|
    t.binary   "_regid",                          null: false
    t.datetime "_period",                         null: false
    t.boolean  "_actualperiod",                   null: false
    t.decimal  "_periodicity",      precision: 2, null: false
    t.decimal  "_repetitionfactor", precision: 2, null: false
    t.decimal  "_usetotals",        precision: 1, null: false
    t.datetime "_minperiod",                      null: false
    t.boolean  "_usesplitter",                    null: false
  end

  add_index "_accumrgopt1631", ["_regid"], name: "_accumr1631_byregid_b", unique: true, using: :btree

  create_table "_accumrgopt1632", id: false, force: :cascade do |t|
    t.binary   "_regid",                          null: false
    t.datetime "_period",                         null: false
    t.boolean  "_actualperiod",                   null: false
    t.decimal  "_periodicity",      precision: 2, null: false
    t.decimal  "_repetitionfactor", precision: 2, null: false
    t.decimal  "_usetotals",        precision: 1, null: false
    t.datetime "_minperiod",                      null: false
    t.boolean  "_usesplitter",                    null: false
  end

  add_index "_accumrgopt1632", ["_regid"], name: "_accumr1632_byregid_b", unique: true, using: :btree

  create_table "_accumrgopt1633", id: false, force: :cascade do |t|
    t.binary   "_regid",                          null: false
    t.datetime "_period",                         null: false
    t.boolean  "_actualperiod",                   null: false
    t.decimal  "_periodicity",      precision: 2, null: false
    t.decimal  "_repetitionfactor", precision: 2, null: false
    t.decimal  "_usetotals",        precision: 1, null: false
    t.datetime "_minperiod",                      null: false
    t.boolean  "_usesplitter",                    null: false
  end

  add_index "_accumrgopt1633", ["_regid"], name: "_accumr1633_byregid_b", unique: true, using: :btree

  create_table "_accumrgopt1634", id: false, force: :cascade do |t|
    t.binary   "_regid",                          null: false
    t.datetime "_period",                         null: false
    t.boolean  "_actualperiod",                   null: false
    t.decimal  "_periodicity",      precision: 2, null: false
    t.decimal  "_repetitionfactor", precision: 2, null: false
    t.decimal  "_usetotals",        precision: 1, null: false
    t.datetime "_minperiod",                      null: false
    t.boolean  "_usesplitter",                    null: false
  end

  add_index "_accumrgopt1634", ["_regid"], name: "_accumr1634_byregid_b", unique: true, using: :btree

  create_table "_accumrgopt1635", id: false, force: :cascade do |t|
    t.binary   "_regid",                          null: false
    t.datetime "_period",                         null: false
    t.boolean  "_actualperiod",                   null: false
    t.decimal  "_periodicity",      precision: 2, null: false
    t.decimal  "_repetitionfactor", precision: 2, null: false
    t.decimal  "_usetotals",        precision: 1, null: false
    t.datetime "_minperiod",                      null: false
    t.boolean  "_usesplitter",                    null: false
  end

  add_index "_accumrgopt1635", ["_regid"], name: "_accumr1635_byregid_b", unique: true, using: :btree

  create_table "_accumrgopt1636", id: false, force: :cascade do |t|
    t.binary   "_regid",                          null: false
    t.datetime "_period",                         null: false
    t.boolean  "_actualperiod",                   null: false
    t.decimal  "_periodicity",      precision: 2, null: false
    t.decimal  "_repetitionfactor", precision: 2, null: false
    t.decimal  "_usetotals",        precision: 1, null: false
    t.datetime "_minperiod",                      null: false
    t.boolean  "_usesplitter",                    null: false
  end

  add_index "_accumrgopt1636", ["_regid"], name: "_accumr1636_byregid_b", unique: true, using: :btree

  create_table "_accumrgopt1637", id: false, force: :cascade do |t|
    t.binary   "_regid",                          null: false
    t.datetime "_period",                         null: false
    t.boolean  "_actualperiod",                   null: false
    t.decimal  "_periodicity",      precision: 2, null: false
    t.decimal  "_repetitionfactor", precision: 2, null: false
    t.decimal  "_usetotals",        precision: 1, null: false
    t.datetime "_minperiod",                      null: false
    t.boolean  "_usesplitter",                    null: false
  end

  add_index "_accumrgopt1637", ["_regid"], name: "_accumr1637_byregid_b", unique: true, using: :btree

  create_table "_accumrgopt1638", id: false, force: :cascade do |t|
    t.binary   "_regid",                          null: false
    t.datetime "_period",                         null: false
    t.boolean  "_actualperiod",                   null: false
    t.decimal  "_periodicity",      precision: 2, null: false
    t.decimal  "_repetitionfactor", precision: 2, null: false
    t.decimal  "_usetotals",        precision: 1, null: false
    t.datetime "_minperiod",                      null: false
    t.boolean  "_usesplitter",                    null: false
  end

  add_index "_accumrgopt1638", ["_regid"], name: "_accumr1638_byregid_b", unique: true, using: :btree

  create_table "_accumrgopt1639", id: false, force: :cascade do |t|
    t.binary   "_regid",                          null: false
    t.datetime "_period",                         null: false
    t.boolean  "_actualperiod",                   null: false
    t.decimal  "_periodicity",      precision: 2, null: false
    t.decimal  "_repetitionfactor", precision: 2, null: false
    t.decimal  "_usetotals",        precision: 1, null: false
    t.datetime "_minperiod",                      null: false
    t.boolean  "_usesplitter",                    null: false
  end

  add_index "_accumrgopt1639", ["_regid"], name: "_accumr1639_byregid_b", unique: true, using: :btree

  create_table "_accumrgopt1640", id: false, force: :cascade do |t|
    t.binary   "_regid",                          null: false
    t.datetime "_period",                         null: false
    t.boolean  "_actualperiod",                   null: false
    t.decimal  "_periodicity",      precision: 2, null: false
    t.decimal  "_repetitionfactor", precision: 2, null: false
    t.decimal  "_usetotals",        precision: 1, null: false
    t.datetime "_minperiod",                      null: false
    t.boolean  "_usesplitter",                    null: false
  end

  add_index "_accumrgopt1640", ["_regid"], name: "_accumr1640_byregid_b", unique: true, using: :btree

  create_table "_accumrgopt1641", id: false, force: :cascade do |t|
    t.binary   "_regid",                          null: false
    t.datetime "_period",                         null: false
    t.boolean  "_actualperiod",                   null: false
    t.decimal  "_periodicity",      precision: 2, null: false
    t.decimal  "_repetitionfactor", precision: 2, null: false
    t.decimal  "_usetotals",        precision: 1, null: false
    t.datetime "_minperiod",                      null: false
    t.boolean  "_usesplitter",                    null: false
  end

  add_index "_accumrgopt1641", ["_regid"], name: "_accumr1641_byregid_b", unique: true, using: :btree

  create_table "_accumrgopt1642", id: false, force: :cascade do |t|
    t.binary   "_regid",                          null: false
    t.datetime "_period",                         null: false
    t.boolean  "_actualperiod",                   null: false
    t.decimal  "_periodicity",      precision: 2, null: false
    t.decimal  "_repetitionfactor", precision: 2, null: false
    t.decimal  "_usetotals",        precision: 1, null: false
    t.datetime "_minperiod",                      null: false
    t.boolean  "_usesplitter",                    null: false
  end

  add_index "_accumrgopt1642", ["_regid"], name: "_accumr1642_byregid_b", unique: true, using: :btree

  create_table "_accumrgt1520", id: false, force: :cascade do |t|
    t.datetime "_period",                                 null: false
    t.binary   "_fld1514rref",                            null: false
    t.binary   "_fld1515rref",                            null: false
    t.binary   "_fld1516_type",                           null: false
    t.binary   "_fld1516_rtref",                          null: false
    t.binary   "_fld1516_rrref",                          null: false
    t.decimal  "_fld1517",       precision: 21, scale: 2, null: false
  end

  add_index "_accumrgt1520", ["_period", "_fld1514rref", "_fld1515rref", "_fld1516_type", "_fld1516_rtref", "_fld1516_rrref"], name: "_accumr1520_bydims_trrr", unique: true, using: :btree
  add_index "_accumrgt1520", ["_period", "_fld1515rref"], name: "_accumr1520_bydims1519_tr", using: :btree

  create_table "_accumrgt1526", id: false, force: :cascade do |t|
    t.datetime "_period",                               null: false
    t.binary   "_fld1523rref",                          null: false
    t.binary   "_fld1524rref",                          null: false
    t.decimal  "_fld1525",     precision: 21, scale: 2, null: false
  end

  add_index "_accumrgt1526", ["_period", "_fld1523rref", "_fld1524rref"], name: "_accumr1526_bydims_trr", unique: true, using: :btree

  create_table "_accumrgt1531", id: false, force: :cascade do |t|
    t.datetime "_period",                               null: false
    t.binary   "_fld1529rref",                          null: false
    t.decimal  "_fld1530",     precision: 21, scale: 2, null: false
  end

  add_index "_accumrgt1531", ["_period", "_fld1529rref"], name: "_accumr1531_bydims_tr", unique: true, using: :btree

  create_table "_accumrgt1566", id: false, force: :cascade do |t|
    t.datetime "_period",                               null: false
    t.binary   "_fld1558rref",                          null: false
    t.binary   "_fld1559rref",                          null: false
    t.binary   "_fld1560rref",                          null: false
    t.binary   "_fld1561rref",                          null: false
    t.decimal  "_fld1562",     precision: 15, scale: 2, null: false
    t.decimal  "_fld1563",     precision: 21, scale: 3, null: false
    t.decimal  "_fld1564",     precision: 21, scale: 2, null: false
  end

  add_index "_accumrgt1566", ["_period", "_fld1558rref", "_fld1559rref", "_fld1560rref", "_fld1561rref", "_fld1562"], name: "_accumr1566_bydims_trrrrn", unique: true, using: :btree
  add_index "_accumrgt1566", ["_period", "_fld1559rref"], name: "_accumr1566_bydims1565_tr", using: :btree

  create_table "_accumrgt1586", id: false, force: :cascade do |t|
    t.datetime "_period",                                 null: false
    t.binary   "_fld1580rref",                            null: false
    t.binary   "_fld1581rref",                            null: false
    t.binary   "_fld1582_type",                           null: false
    t.binary   "_fld1582_rtref",                          null: false
    t.binary   "_fld1582_rrref",                          null: false
    t.decimal  "_fld1583",       precision: 21, scale: 6, null: false
    t.decimal  "_fld1584",       precision: 21, scale: 3, null: false
  end

  add_index "_accumrgt1586", ["_period", "_fld1580rref", "_fld1581rref", "_fld1582_type", "_fld1582_rtref", "_fld1582_rrref"], name: "_accumr1586_bydims_trrr", unique: true, using: :btree

  create_table "_accumrgt1608", id: false, force: :cascade do |t|
    t.datetime "_period",                               null: false
    t.binary   "_fld1606rref",                          null: false
    t.decimal  "_fld1607",     precision: 21, scale: 2, null: false
    t.decimal  "_splitter",    precision: 10,           null: false
  end

  add_index "_accumrgt1608", ["_period", "_fld1606rref", "_splitter"], name: "_accumr1608_bydims_trn", unique: true, using: :btree

  create_table "_accumrgt1618", id: false, force: :cascade do |t|
    t.datetime "_period",                               null: false
    t.binary   "_fld1611rref",                          null: false
    t.binary   "_fld1612rref",                          null: false
    t.binary   "_fld1613rref",                          null: false
    t.binary   "_fld1614rref",                          null: false
    t.binary   "_fld1615rref",                          null: false
    t.decimal  "_fld1616",     precision: 18, scale: 3, null: false
    t.decimal  "_fld1617",     precision: 19, scale: 2, null: false
    t.decimal  "_splitter",    precision: 10,           null: false
  end

  add_index "_accumrgt1618", ["_period", "_fld1611rref", "_fld1612rref", "_fld1613rref", "_fld1614rref", "_fld1615rref", "_splitter"], name: "_accumr1618_bydims_trrrrrn", unique: true, using: :btree

  create_table "_accumrgtn1577", id: false, force: :cascade do |t|
    t.datetime "_period",                               null: false
    t.binary   "_fld1569rref",                          null: false
    t.binary   "_fld1570rref",                          null: false
    t.binary   "_fld1571rref",                          null: false
    t.binary   "_fld1572rref",                          null: false
    t.decimal  "_fld1573",     precision: 21, scale: 3, null: false
    t.decimal  "_fld1574",     precision: 21, scale: 2, null: false
    t.decimal  "_fld1575",     precision: 21, scale: 2, null: false
  end

  add_index "_accumrgtn1577", ["_fld1572rref", "_period"], name: "_accumr1577_bydims1576_rt", using: :btree
  add_index "_accumrgtn1577", ["_period", "_fld1569rref", "_fld1570rref", "_fld1571rref", "_fld1572rref"], name: "_accumr1577_bydims_trrrr", unique: true, using: :btree

  create_table "_accumrgtn1595", id: false, force: :cascade do |t|
    t.datetime "_period",                               null: false
    t.binary   "_fld1589rref",                          null: false
    t.binary   "_fld1590rref",                          null: false
    t.binary   "_fld1591rref",                          null: false
    t.binary   "_fld1592rref",                          null: false
    t.decimal  "_fld1593",     precision: 21, scale: 3, null: false
    t.decimal  "_fld1594",     precision: 21, scale: 2, null: false
  end

  add_index "_accumrgtn1595", ["_period", "_fld1589rref", "_fld1590rref", "_fld1591rref", "_fld1592rref"], name: "_accumr1595_bydims_trrrr", unique: true, using: :btree

  create_table "_accumrgtn1603", id: false, force: :cascade do |t|
    t.datetime "_period",                               null: false
    t.binary   "_fld1598rref",                          null: false
    t.binary   "_fld1599rref",                          null: false
    t.binary   "_fld1600rref",                          null: false
    t.decimal  "_fld1601",     precision: 21, scale: 3, null: false
    t.decimal  "_fld1602",     precision: 21, scale: 2, null: false
    t.decimal  "_splitter",    precision: 10,           null: false
  end

  add_index "_accumrgtn1603", ["_period", "_fld1598rref", "_fld1599rref", "_fld1600rref", "_splitter"], name: "_accumr1603_bydims_trrrn", unique: true, using: :btree

  create_table "_accumrgtn1623", id: false, force: :cascade do |t|
    t.datetime "_period",                     null: false
    t.binary   "_fld1621rref",                null: false
    t.decimal  "_fld1622",     precision: 21, null: false
    t.decimal  "_splitter",    precision: 10, null: false
  end

  add_index "_accumrgtn1623", ["_period", "_fld1621rref", "_splitter"], name: "_accumr1623_bydims_trn", unique: true, using: :btree

  create_table "_accumrgtn1628", id: false, force: :cascade do |t|
    t.datetime "_period",                               null: false
    t.binary   "_fld1626rref",                          null: false
    t.decimal  "_fld1627",     precision: 21, scale: 2, null: false
    t.decimal  "_splitter",    precision: 10,           null: false
  end

  add_index "_accumrgtn1628", ["_period", "_fld1626rref", "_splitter"], name: "_accumr1628_bydims_trn", unique: true, using: :btree

  create_table "_chrcchngr1646", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_chrcchngr1646", ["_idrref", "_nodetref", "_noderref"], name: "_chrcch1646_bydatakey_rr", unique: true, using: :btree
  add_index "_chrcchngr1646", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_chrcch1646_bynodemsg_rnr", unique: true, using: :btree

  create_table "_chrcchngr1647", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_chrcchngr1647", ["_idrref", "_nodetref", "_noderref"], name: "_chrcch1647_bydatakey_rr", unique: true, using: :btree
  add_index "_chrcchngr1647", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_chrcch1647_bynodemsg_rnr", unique: true, using: :btree

  create_table "_chrcchngr1648", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_chrcchngr1648", ["_idrref", "_nodetref", "_noderref"], name: "_chrcch1648_bydatakey_rr", unique: true, using: :btree
  add_index "_chrcchngr1648", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_chrcch1648_bynodemsg_rnr", unique: true, using: :btree

  create_table "_configchngr", primary_key: "_idrref", force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_mdobjid",                  null: false
  end

  add_index "_configchngr", ["_mdobjid", "_nodetref", "_noderref"], name: "_configchng_bydatakey_br", unique: true, using: :btree
  add_index "_configchngr", ["_nodetref", "_noderref", "_messageno", "_mdobjid"], name: "_configchng_bynodemsg_rnb", unique: true, using: :btree

  create_table "_const1122", id: false, force: :cascade do |t|
    t.decimal "_fld1123",   precision: 10, null: false
    t.binary  "_recordkey",                null: false
  end

  add_index "_const1122", ["_recordkey"], name: "_const1122_bykey_b", unique: true, using: :btree

  create_table "_const1131", id: false, force: :cascade do |t|
    t.boolean "_fld1132",   null: false
    t.binary  "_recordkey", null: false
  end

  add_index "_const1131", ["_recordkey"], name: "_const1131_bykey_b", unique: true, using: :btree

  create_table "_const1136", id: false, force: :cascade do |t|
    t.boolean "_fld1137",   null: false
    t.binary  "_recordkey", null: false
  end

  add_index "_const1136", ["_recordkey"], name: "_const1136_bykey_b", unique: true, using: :btree

  create_table "_const1141", id: false, force: :cascade do |t|
    t.boolean "_fld1142",   null: false
    t.binary  "_recordkey", null: false
  end

  add_index "_const1141", ["_recordkey"], name: "_const1141_bykey_b", unique: true, using: :btree

  create_table "_const1144", id: false, force: :cascade do |t|
    t.boolean "_fld1145",   null: false
    t.binary  "_recordkey", null: false
  end

  add_index "_const1144", ["_recordkey"], name: "_const1144_bykey_b", unique: true, using: :btree

  create_table "_const1147", id: false, force: :cascade do |t|
    t.boolean "_fld1148",   null: false
    t.binary  "_recordkey", null: false
  end

  add_index "_const1147", ["_recordkey"], name: "_const1147_bykey_b", unique: true, using: :btree

  create_table "_const1150", id: false, force: :cascade do |t|
    t.binary "_fld1151rref", null: false
    t.binary "_recordkey",   null: false
  end

  add_index "_const1150", ["_recordkey"], name: "_const1150_bykey_b", unique: true, using: :btree

  create_table "_const1152", id: false, force: :cascade do |t|
    t.datetime "_fld1153",   null: false
    t.binary   "_recordkey", null: false
  end

  add_index "_const1152", ["_recordkey"], name: "_const1152_bykey_b", unique: true, using: :btree

  create_table "_const1155", id: false, force: :cascade do |t|
    t.boolean "_fld1156",   null: false
    t.binary  "_recordkey", null: false
  end

  add_index "_const1155", ["_recordkey"], name: "_const1155_bykey_b", unique: true, using: :btree

  create_table "_const1158", id: false, force: :cascade do |t|
    t.binary "_fld1159rref", null: false
    t.binary "_recordkey",   null: false
  end

  add_index "_const1158", ["_recordkey"], name: "_const1158_bykey_b", unique: true, using: :btree

  create_table "_const1160", id: false, force: :cascade do |t|
    t.binary "_fld1161",   null: false
    t.binary "_recordkey", null: false
  end

  add_index "_const1160", ["_recordkey"], name: "_const1160_bykey_b", unique: true, using: :btree

  create_table "_const1162", id: false, force: :cascade do |t|
    t.binary "_fld1163rref", null: false
    t.binary "_recordkey",   null: false
  end

  add_index "_const1162", ["_recordkey"], name: "_const1162_bykey_b", unique: true, using: :btree

  create_table "_const1164", id: false, force: :cascade do |t|
    t.boolean "_fld1165",   null: false
    t.binary  "_recordkey", null: false
  end

  add_index "_const1164", ["_recordkey"], name: "_const1164_bykey_b", unique: true, using: :btree

  create_table "_const1166", id: false, force: :cascade do |t|
    t.binary "_fld1167",   null: false
    t.binary "_recordkey", null: false
  end

  add_index "_const1166", ["_recordkey"], name: "_const1166_bykey_b", unique: true, using: :btree

  create_table "_const1170", id: false, force: :cascade do |t|
    t.datetime "_fld1171",   null: false
    t.binary   "_recordkey", null: false
  end

  add_index "_const1170", ["_recordkey"], name: "_const1170_bykey_b", unique: true, using: :btree

  create_table "_const1172", id: false, force: :cascade do |t|
    t.boolean "_fld1173",   null: false
    t.binary  "_recordkey", null: false
  end

  add_index "_const1172", ["_recordkey"], name: "_const1172_bykey_b", unique: true, using: :btree

  create_table "_const1174", id: false, force: :cascade do |t|
    t.binary "_fld1175",   null: false
    t.binary "_recordkey", null: false
  end

  add_index "_const1174", ["_recordkey"], name: "_const1174_bykey_b", unique: true, using: :btree

  create_table "_const1176", id: false, force: :cascade do |t|
    t.binary "_fld1177rref", null: false
    t.binary "_recordkey",   null: false
  end

  add_index "_const1176", ["_recordkey"], name: "_const1176_bykey_b", unique: true, using: :btree

  create_table "_const1178", id: false, force: :cascade do |t|
    t.decimal "_fld1179",   precision: 10, null: false
    t.binary  "_recordkey",                null: false
  end

  add_index "_const1178", ["_recordkey"], name: "_const1178_bykey_b", unique: true, using: :btree

  create_table "_const1180", id: false, force: :cascade do |t|
    t.binary "_fld1181",   null: false
    t.binary "_recordkey", null: false
  end

  add_index "_const1180", ["_recordkey"], name: "_const1180_bykey_b", unique: true, using: :btree

  create_table "_const1182", id: false, force: :cascade do |t|
    t.binary "_fld1183",   null: false
    t.binary "_recordkey", null: false
  end

  add_index "_const1182", ["_recordkey"], name: "_const1182_bykey_b", unique: true, using: :btree

  create_table "_const1186", id: false, force: :cascade do |t|
    t.decimal "_fld1187",   precision: 10, null: false
    t.binary  "_recordkey",                null: false
  end

  add_index "_const1186", ["_recordkey"], name: "_const1186_bykey_b", unique: true, using: :btree

  create_table "_const1188", id: false, force: :cascade do |t|
    t.decimal "_fld1189",   precision: 2, null: false
    t.binary  "_recordkey",               null: false
  end

  add_index "_const1188", ["_recordkey"], name: "_const1188_bykey_b", unique: true, using: :btree

  create_table "_const1190", id: false, force: :cascade do |t|
    t.decimal "_fld1191",   precision: 9, null: false
    t.binary  "_recordkey",               null: false
  end

  add_index "_const1190", ["_recordkey"], name: "_const1190_bykey_b", unique: true, using: :btree

  create_table "_const1192", id: false, force: :cascade do |t|
    t.decimal "_fld1193",   precision: 4, scale: 1, null: false
    t.binary  "_recordkey",                         null: false
  end

  add_index "_const1192", ["_recordkey"], name: "_const1192_bykey_b", unique: true, using: :btree

  create_table "_const1194", id: false, force: :cascade do |t|
    t.datetime "_fld1195",   null: false
    t.binary   "_recordkey", null: false
  end

  add_index "_const1194", ["_recordkey"], name: "_const1194_bykey_b", unique: true, using: :btree

  create_table "_const1196", id: false, force: :cascade do |t|
    t.boolean "_fld1197",   null: false
    t.binary  "_recordkey", null: false
  end

  add_index "_const1196", ["_recordkey"], name: "_const1196_bykey_b", unique: true, using: :btree

  create_table "_const1199", id: false, force: :cascade do |t|
    t.boolean "_fld1200",   null: false
    t.binary  "_recordkey", null: false
  end

  add_index "_const1199", ["_recordkey"], name: "_const1199_bykey_b", unique: true, using: :btree

  create_table "_const1201", id: false, force: :cascade do |t|
    t.boolean "_fld1202",   null: false
    t.binary  "_recordkey", null: false
  end

  add_index "_const1201", ["_recordkey"], name: "_const1201_bykey_b", unique: true, using: :btree

  create_table "_constchngr1121", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_constid",                  null: false
  end

  add_index "_constchngr1121", ["_constid", "_nodetref", "_noderref"], name: "_constc1121_bydatakey_br", unique: true, using: :btree
  add_index "_constchngr1121", ["_nodetref", "_noderref", "_messageno", "_constid"], name: "_constc1121_bynodemsg_rnb", unique: true, using: :btree

  create_table "_constchngr1124", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_constid",                  null: false
  end

  add_index "_constchngr1124", ["_constid", "_nodetref", "_noderref"], name: "_constc1124_bydatakey_br", unique: true, using: :btree
  add_index "_constchngr1124", ["_nodetref", "_noderref", "_messageno", "_constid"], name: "_constc1124_bynodemsg_rnb", unique: true, using: :btree

  create_table "_constchngr1127", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_constid",                  null: false
  end

  add_index "_constchngr1127", ["_constid", "_nodetref", "_noderref"], name: "_constc1127_bydatakey_br", unique: true, using: :btree
  add_index "_constchngr1127", ["_nodetref", "_noderref", "_messageno", "_constid"], name: "_constc1127_bynodemsg_rnb", unique: true, using: :btree

  create_table "_constchngr1130", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_constid",                  null: false
  end

  add_index "_constchngr1130", ["_constid", "_nodetref", "_noderref"], name: "_constc1130_bydatakey_br", unique: true, using: :btree
  add_index "_constchngr1130", ["_nodetref", "_noderref", "_messageno", "_constid"], name: "_constc1130_bynodemsg_rnb", unique: true, using: :btree

  create_table "_constchngr1133", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_constid",                  null: false
  end

  add_index "_constchngr1133", ["_constid", "_nodetref", "_noderref"], name: "_constc1133_bydatakey_br", unique: true, using: :btree
  add_index "_constchngr1133", ["_nodetref", "_noderref", "_messageno", "_constid"], name: "_constc1133_bynodemsg_rnb", unique: true, using: :btree

  create_table "_constchngr1138", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_constid",                  null: false
  end

  add_index "_constchngr1138", ["_constid", "_nodetref", "_noderref"], name: "_constc1138_bydatakey_br", unique: true, using: :btree
  add_index "_constchngr1138", ["_nodetref", "_noderref", "_messageno", "_constid"], name: "_constc1138_bynodemsg_rnb", unique: true, using: :btree

  create_table "_constchngr1143", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_constid",                  null: false
  end

  add_index "_constchngr1143", ["_constid", "_nodetref", "_noderref"], name: "_constc1143_bydatakey_br", unique: true, using: :btree
  add_index "_constchngr1143", ["_nodetref", "_noderref", "_messageno", "_constid"], name: "_constc1143_bynodemsg_rnb", unique: true, using: :btree

  create_table "_constchngr1146", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_constid",                  null: false
  end

  add_index "_constchngr1146", ["_constid", "_nodetref", "_noderref"], name: "_constc1146_bydatakey_br", unique: true, using: :btree
  add_index "_constchngr1146", ["_nodetref", "_noderref", "_messageno", "_constid"], name: "_constc1146_bynodemsg_rnb", unique: true, using: :btree

  create_table "_constchngr1149", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_constid",                  null: false
  end

  add_index "_constchngr1149", ["_constid", "_nodetref", "_noderref"], name: "_constc1149_bydatakey_br", unique: true, using: :btree
  add_index "_constchngr1149", ["_nodetref", "_noderref", "_messageno", "_constid"], name: "_constc1149_bynodemsg_rnb", unique: true, using: :btree

  create_table "_constchngr1154", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_constid",                  null: false
  end

  add_index "_constchngr1154", ["_constid", "_nodetref", "_noderref"], name: "_constc1154_bydatakey_br", unique: true, using: :btree
  add_index "_constchngr1154", ["_nodetref", "_noderref", "_messageno", "_constid"], name: "_constc1154_bynodemsg_rnb", unique: true, using: :btree

  create_table "_constchngr1157", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_constid",                  null: false
  end

  add_index "_constchngr1157", ["_constid", "_nodetref", "_noderref"], name: "_constc1157_bydatakey_br", unique: true, using: :btree
  add_index "_constchngr1157", ["_nodetref", "_noderref", "_messageno", "_constid"], name: "_constc1157_bynodemsg_rnb", unique: true, using: :btree

  create_table "_constchngr1198", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_constid",                  null: false
  end

  add_index "_constchngr1198", ["_constid", "_nodetref", "_noderref"], name: "_constc1198_bydatakey_br", unique: true, using: :btree
  add_index "_constchngr1198", ["_nodetref", "_noderref", "_messageno", "_constid"], name: "_constc1198_bynodemsg_rnb", unique: true, using: :btree

  create_table "_document52_vt553", id: false, force: :cascade do |t|
    t.binary  "_document52_idrref",                          null: false
    t.binary  "_keyfield",                                   null: false
    t.decimal "_lineno554",         precision: 5,            null: false
    t.binary  "_fld555rref",                                 null: false
    t.decimal "_fld556",            precision: 10, scale: 2, null: false
    t.decimal "_fld557",            precision: 15, scale: 3, null: false
    t.decimal "_fld558",            precision: 15, scale: 3, null: false
    t.binary  "_fld559rref",                                 null: false
    t.decimal "_fld560",            precision: 10, scale: 3, null: false
    t.decimal "_fld561",            precision: 10, scale: 2, null: false
    t.decimal "_fld562",            precision: 10, scale: 2, null: false
  end

  add_index "_document52_vt553", ["_document52_idrref", "_keyfield"], name: "_document52_vt553_intkeyind", unique: true, using: :btree

  create_table "_document54_vt595", id: false, force: :cascade do |t|
    t.binary  "_document54_idrref",                          null: false
    t.binary  "_keyfield",                                   null: false
    t.decimal "_lineno596",         precision: 5,            null: false
    t.binary  "_fld597rref",                                 null: false
    t.binary  "_fld598rref",                                 null: false
    t.decimal "_fld599",            precision: 10, scale: 3, null: false
    t.decimal "_fld600",            precision: 15, scale: 3, null: false
    t.binary  "_fld601rref",                                 null: false
  end

  add_index "_document54_vt595", ["_document54_idrref", "_keyfield"], name: "_document54_vt595_intkeyind", unique: true, using: :btree

  create_table "_document55_vt615", id: false, force: :cascade do |t|
    t.binary  "_document55_idrref",                          null: false
    t.binary  "_keyfield",                                   null: false
    t.decimal "_lineno616",         precision: 5,            null: false
    t.binary  "_fld617rref",                                 null: false
    t.decimal "_fld618",            precision: 15, scale: 3, null: false
    t.binary  "_fld619rref",                                 null: false
    t.decimal "_fld620",            precision: 10, scale: 3, null: false
    t.decimal "_fld621",            precision: 15, scale: 2, null: false
    t.binary  "_fld622rref",                                 null: false
    t.decimal "_fld623",            precision: 15, scale: 2, null: false
    t.decimal "_fld624",            precision: 15, scale: 2, null: false
    t.decimal "_fld625",            precision: 15, scale: 2, null: false
  end

  add_index "_document55_vt615", ["_document55_idrref", "_keyfield"], name: "_document55_vt615_intkeyind", unique: true, using: :btree

  create_table "_document56_vt669", id: false, force: :cascade do |t|
    t.binary  "_document56_idrref",               null: false
    t.binary  "_keyfield",                        null: false
    t.decimal "_lineno670",         precision: 5, null: false
    t.binary  "_fld671rref",                      null: false
  end

  add_index "_document56_vt669", ["_document56_idrref", "_keyfield"], name: "_document56_vt669_intkeyind", unique: true, using: :btree

  create_table "_document56_vt672", id: false, force: :cascade do |t|
    t.binary  "_document56_idrref",               null: false
    t.binary  "_keyfield",                        null: false
    t.decimal "_lineno673",         precision: 5, null: false
    t.binary  "_fld674rref",                      null: false
  end

  add_index "_document56_vt672", ["_document56_idrref", "_keyfield"], name: "_document56_vt672_intkeyind", unique: true, using: :btree

  create_table "_document56_vt675", id: false, force: :cascade do |t|
    t.binary   "_document56_idrref",                          null: false
    t.binary   "_keyfield",                                   null: false
    t.decimal  "_lineno676",         precision: 5,            null: false
    t.decimal  "_fld677",            precision: 15, scale: 2, null: false
    t.datetime "_fld678",                                     null: false
  end

  add_index "_document56_vt675", ["_document56_idrref", "_keyfield"], name: "_document56_vt675_intkeyind", unique: true, using: :btree

  create_table "_document57_vt689", id: false, force: :cascade do |t|
    t.binary  "_document57_idrref",                          null: false
    t.binary  "_keyfield",                                   null: false
    t.decimal "_lineno690",         precision: 5,            null: false
    t.binary  "_fld691rref",                                 null: false
    t.binary  "_fld692rref",                                 null: false
    t.decimal "_fld693",            precision: 10, scale: 3, null: false
    t.decimal "_fld694",            precision: 15, scale: 3, null: false
    t.decimal "_fld695",            precision: 15, scale: 2, null: false
    t.decimal "_fld696",            precision: 15, scale: 2, null: false
    t.binary  "_fld697rref",                                 null: false
    t.decimal "_fld698",            precision: 15, scale: 2, null: false
    t.decimal "_fld699",            precision: 15, scale: 2, null: false
  end

  add_index "_document57_vt689", ["_document57_idrref", "_keyfield"], name: "_document57_vt689_intkeyind", unique: true, using: :btree

  create_table "_document58_vt706", id: false, force: :cascade do |t|
    t.binary  "_document58_idrref",                          null: false
    t.binary  "_keyfield",                                   null: false
    t.decimal "_lineno707",         precision: 5,            null: false
    t.binary  "_fld708rref",                                 null: false
    t.binary  "_fld709rref",                                 null: false
    t.decimal "_fld710",            precision: 10, scale: 3, null: false
    t.decimal "_fld711",            precision: 15, scale: 3, null: false
    t.decimal "_fld712",            precision: 15, scale: 2, null: false
    t.decimal "_fld713",            precision: 15, scale: 2, null: false
    t.decimal "_fld714",            precision: 15, scale: 3, null: false
    t.decimal "_fld715",            precision: 15, scale: 2, null: false
    t.decimal "_fld716",            precision: 15, scale: 2, null: false
    t.decimal "_fld717",            precision: 15,           null: false
    t.decimal "_fld718",            precision: 15, scale: 2, null: false
    t.binary  "_fld719rref",                                 null: false
  end

  add_index "_document58_vt706", ["_document58_idrref", "_keyfield"], name: "_document58_vt706_intkeyind", unique: true, using: :btree

  create_table "_document59_vt727", id: false, force: :cascade do |t|
    t.binary  "_document59_idrref",                          null: false
    t.binary  "_keyfield",                                   null: false
    t.decimal "_lineno728",         precision: 5,            null: false
    t.binary  "_fld729rref",                                 null: false
    t.decimal "_fld730",            precision: 15, scale: 2, null: false
    t.binary  "_fld731rref",                                 null: false
  end

  add_index "_document59_vt727", ["_document59_idrref", "_keyfield"], name: "_document59_vt727_intkeyind", unique: true, using: :btree

  create_table "_document60_vt740", id: false, force: :cascade do |t|
    t.binary  "_document60_idrref",                          null: false
    t.binary  "_keyfield",                                   null: false
    t.decimal "_lineno741",         precision: 5,            null: false
    t.binary  "_fld742rref",                                 null: false
    t.decimal "_fld743",            precision: 15, scale: 3, null: false
    t.binary  "_fld744rref",                                 null: false
    t.decimal "_fld745",            precision: 10, scale: 3, null: false
    t.decimal "_fld746",            precision: 15, scale: 2, null: false
    t.decimal "_fld747",            precision: 15, scale: 2, null: false
    t.decimal "_fld748",            precision: 15, scale: 2, null: false
    t.decimal "_fld749",            precision: 15, scale: 2, null: false
  end

  add_index "_document60_vt740", ["_document60_idrref", "_keyfield"], name: "_document60_vt740_intkeyind", unique: true, using: :btree

  create_table "_document61_vt754", id: false, force: :cascade do |t|
    t.binary  "_document61_idrref",               null: false
    t.binary  "_keyfield",                        null: false
    t.decimal "_lineno755",         precision: 5, null: false
    t.binary  "_fld756rref",                      null: false
    t.binary  "_fld757rref",                      null: false
  end

  add_index "_document61_vt754", ["_document61_idrref", "_keyfield"], name: "_document61_vt754_intkeyind", unique: true, using: :btree

  create_table "_document62_vt765", id: false, force: :cascade do |t|
    t.binary  "_document62_idrref",                          null: false
    t.binary  "_keyfield",                                   null: false
    t.decimal "_lineno766",         precision: 5,            null: false
    t.binary  "_fld767rref",                                 null: false
    t.decimal "_fld768",            precision: 15, scale: 3, null: false
    t.decimal "_fld769",            precision: 10, scale: 3, null: false
    t.binary  "_fld770rref",                                 null: false
  end

  add_index "_document62_vt765", ["_document62_idrref", "_keyfield"], name: "_document62_vt765_intkeyind", unique: true, using: :btree

  create_table "_document63_vt784", id: false, force: :cascade do |t|
    t.binary  "_document63_idrref",                          null: false
    t.binary  "_keyfield",                                   null: false
    t.decimal "_lineno785",         precision: 5,            null: false
    t.binary  "_fld786rref",                                 null: false
    t.binary  "_fld787rref",                                 null: false
    t.decimal "_fld788",            precision: 10, scale: 3, null: false
    t.binary  "_fld789rref",                                 null: false
    t.decimal "_fld790",            precision: 15, scale: 3, null: false
    t.decimal "_fld791",            precision: 15, scale: 2, null: false
    t.decimal "_fld792",            precision: 5,            null: false
    t.decimal "_fld793",            precision: 5,            null: false
  end

  add_index "_document63_vt784", ["_document63_idrref", "_keyfield"], name: "_document63_vt784_intkeyind", unique: true, using: :btree

  create_table "_document63_vt794", id: false, force: :cascade do |t|
    t.binary  "_document63_idrref",                          null: false
    t.binary  "_keyfield",                                   null: false
    t.decimal "_lineno795",         precision: 5,            null: false
    t.binary  "_fld796rref",                                 null: false
    t.decimal "_fld797",            precision: 15, scale: 3, null: false
    t.decimal "_fld798",            precision: 15, scale: 3, null: false
    t.decimal "_fld799",            precision: 5,            null: false
    t.decimal "_fld800",            precision: 15, scale: 2, null: false
    t.decimal "_fld801",            precision: 5,            null: false
    t.boolean "_fld802",                                     null: false
    t.boolean "_fld803",                                     null: false
    t.binary  "_fld804rref",                                 null: false
  end

  add_index "_document63_vt794", ["_document63_idrref", "_keyfield"], name: "_document63_vt794_intkeyind", unique: true, using: :btree

  create_table "_document68_vt941", id: false, force: :cascade do |t|
    t.binary  "_document68_idrref",                          null: false
    t.binary  "_keyfield",                                   null: false
    t.decimal "_lineno942",         precision: 5,            null: false
    t.binary  "_fld943rref",                                 null: false
    t.decimal "_fld944",            precision: 15, scale: 3, null: false
    t.decimal "_fld945",            precision: 10, scale: 3, null: false
    t.binary  "_fld946rref",                                 null: false
    t.decimal "_fld947",            precision: 15, scale: 4, null: false
    t.decimal "_fld948",            precision: 15, scale: 2, null: false
    t.binary  "_fld949rref",                                 null: false
  end

  add_index "_document68_vt941", ["_document68_idrref", "_keyfield"], name: "_document68_vt941_intkeyind", unique: true, using: :btree

  create_table "_document69_vt967", id: false, force: :cascade do |t|
    t.binary  "_document69_idrref",                          null: false
    t.binary  "_keyfield",                                   null: false
    t.decimal "_lineno968",         precision: 5,            null: false
    t.binary  "_fld969rref",                                 null: false
    t.decimal "_fld970",            precision: 5,  scale: 2, null: false
    t.decimal "_fld971",            precision: 15, scale: 2, null: false
  end

  add_index "_document69_vt967", ["_document69_idrref", "_keyfield"], name: "_document69_vt967_intkeyind", unique: true, using: :btree

  create_table "_document69_vt972", id: false, force: :cascade do |t|
    t.binary   "_document69_idrref",               null: false
    t.binary   "_keyfield",                        null: false
    t.decimal  "_lineno973",         precision: 5, null: false
    t.boolean  "_fld974",                          null: false
    t.binary   "_fld975rref",                      null: false
    t.datetime "_fld976",                          null: false
    t.datetime "_fld977",                          null: false
  end

  add_index "_document69_vt972", ["_document69_idrref", "_keyfield"], name: "_document69_vt972_intkeyind", unique: true, using: :btree

  create_table "_document69_vt978", id: false, force: :cascade do |t|
    t.binary  "_document69_idrref",               null: false
    t.binary  "_keyfield",                        null: false
    t.decimal "_lineno979",         precision: 5, null: false
    t.binary  "_fld980rref",                      null: false
  end

  add_index "_document69_vt978", ["_document69_idrref", "_keyfield"], name: "_document69_vt978_intkeyind", unique: true, using: :btree

  create_table "_document69_vt981", id: false, force: :cascade do |t|
    t.binary  "_document69_idrref",               null: false
    t.binary  "_keyfield",                        null: false
    t.decimal "_lineno982",         precision: 5, null: false
    t.binary  "_fld983rref",                      null: false
  end

  add_index "_document69_vt981", ["_document69_idrref", "_keyfield"], name: "_document69_vt981_intkeyind", unique: true, using: :btree

  create_table "_document69_vt984", id: false, force: :cascade do |t|
    t.binary  "_document69_idrref",                         null: false
    t.binary  "_keyfield",                                  null: false
    t.decimal "_lineno985",         precision: 5,           null: false
    t.binary  "_fld986rref",                                null: false
    t.decimal "_fld987",            precision: 5, scale: 2, null: false
    t.decimal "_fld988",            precision: 5, scale: 2, null: false
  end

  add_index "_document69_vt984", ["_document69_idrref", "_keyfield"], name: "_document69_vt984_intkeyind", unique: true, using: :btree

  create_table "_document70_vt994", id: false, force: :cascade do |t|
    t.binary  "_document70_idrref",                          null: false
    t.binary  "_keyfield",                                   null: false
    t.decimal "_lineno995",         precision: 5,            null: false
    t.binary  "_fld996rref",                                 null: false
    t.decimal "_fld997",            precision: 15, scale: 2, null: false
    t.binary  "_fld998rref",                                 null: false
    t.decimal "_fld999",            precision: 8,  scale: 1, null: false
    t.decimal "_fld1000",           precision: 8,  scale: 2, null: false
  end

  add_index "_document70_vt994", ["_document70_idrref", "_keyfield"], name: "_document70_vt994_intkeyind", unique: true, using: :btree

  create_table "_document71_vt1007", id: false, force: :cascade do |t|
    t.binary  "_document71_idrref",                          null: false
    t.binary  "_keyfield",                                   null: false
    t.decimal "_lineno1008",        precision: 5,            null: false
    t.binary  "_fld1009rref",                                null: false
    t.binary  "_fld1010rref",                                null: false
    t.decimal "_fld1011",           precision: 10, scale: 3, null: false
    t.decimal "_fld1012",           precision: 15, scale: 3, null: false
    t.decimal "_fld1013",           precision: 15, scale: 2, null: false
    t.decimal "_fld1014",           precision: 15, scale: 2, null: false
    t.decimal "_fld1015",           precision: 15, scale: 2, null: false
    t.decimal "_fld1016",           precision: 15, scale: 2, null: false
    t.decimal "_fld1017",           precision: 5,  scale: 2, null: false
    t.decimal "_fld1018",           precision: 5,  scale: 2, null: false
    t.binary  "_fld1019rref",                                null: false
    t.binary  "_fld1020_type",                               null: false
    t.decimal "_fld1020_n",         precision: 15, scale: 2, null: false
    t.binary  "_fld1020_rrref",                              null: false
    t.binary  "_fld1021rref",                                null: false
    t.decimal "_fld1022",           precision: 15, scale: 2, null: false
  end

  add_index "_document71_vt1007", ["_document71_idrref", "_keyfield"], name: "_document71_vt1007_intkeyind", unique: true, using: :btree

  create_table "_document72_vt1032", id: false, force: :cascade do |t|
    t.binary  "_document72_idrref",               null: false
    t.binary  "_keyfield",                        null: false
    t.decimal "_lineno1033",        precision: 5, null: false
    t.binary  "_fld1034rref",                     null: false
  end

  add_index "_document72_vt1032", ["_document72_idrref", "_keyfield"], name: "_document72_vt1032_intkeyind", unique: true, using: :btree

  create_table "_document72_vt1035", id: false, force: :cascade do |t|
    t.binary  "_document72_idrref",               null: false
    t.binary  "_keyfield",                        null: false
    t.decimal "_lineno1036",        precision: 5, null: false
    t.binary  "_fld1037_type",                    null: false
    t.binary  "_fld1037_rtref",                   null: false
    t.binary  "_fld1037_rrref",                   null: false
  end

  add_index "_document72_vt1035", ["_document72_idrref", "_keyfield"], name: "_document72_vt1035_intkeyind", unique: true, using: :btree

  create_table "_document76_vt1103", id: false, force: :cascade do |t|
    t.binary  "_document76_idrref",               null: false
    t.binary  "_keyfield",                        null: false
    t.decimal "_lineno1104",        precision: 5, null: false
    t.binary  "_fld1105rref",                     null: false
  end

  add_index "_document76_vt1103", ["_document76_idrref", "_keyfield"], name: "_document76_vt1103_intkeyind", unique: true, using: :btree

  create_table "_documentchngr1001", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr1001", ["_idrref", "_nodetref", "_noderref"], name: "_docume1001_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr1001", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_docume1001_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr1023", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr1023", ["_idrref", "_nodetref", "_noderref"], name: "_docume1023_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr1023", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_docume1023_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr1038", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr1038", ["_idrref", "_nodetref", "_noderref"], name: "_docume1038_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr1038", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_docume1038_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr1045", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr1045", ["_idrref", "_nodetref", "_noderref"], name: "_docume1045_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr1045", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_docume1045_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr563", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr563", ["_idrref", "_nodetref", "_noderref"], name: "_documen563_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr563", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_documen563_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr589", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr589", ["_idrref", "_nodetref", "_noderref"], name: "_documen589_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr589", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_documen589_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr603", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr603", ["_idrref", "_nodetref", "_noderref"], name: "_documen603_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr603", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_documen603_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr626", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr626", ["_idrref", "_nodetref", "_noderref"], name: "_documen626_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr626", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_documen626_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr679", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr679", ["_idrref", "_nodetref", "_noderref"], name: "_documen679_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr679", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_documen679_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr701", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr701", ["_idrref", "_nodetref", "_noderref"], name: "_documen701_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr701", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_documen701_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr721", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr721", ["_idrref", "_nodetref", "_noderref"], name: "_documen721_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr721", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_documen721_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr732", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr732", ["_idrref", "_nodetref", "_noderref"], name: "_documen732_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr732", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_documen732_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr751", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr751", ["_idrref", "_nodetref", "_noderref"], name: "_documen751_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr751", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_documen751_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr758", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr758", ["_idrref", "_nodetref", "_noderref"], name: "_documen758_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr758", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_documen758_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr772", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr772", ["_idrref", "_nodetref", "_noderref"], name: "_documen772_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr772", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_documen772_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr805", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr805", ["_idrref", "_nodetref", "_noderref"], name: "_documen805_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr805", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_documen805_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr838", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr838", ["_idrref", "_nodetref", "_noderref"], name: "_documen838_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr838", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_documen838_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr860", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr860", ["_idrref", "_nodetref", "_noderref"], name: "_documen860_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr860", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_documen860_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr881", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr881", ["_idrref", "_nodetref", "_noderref"], name: "_documen881_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr881", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_documen881_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr935", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr935", ["_idrref", "_nodetref", "_noderref"], name: "_documen935_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr935", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_documen935_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr951", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr951", ["_idrref", "_nodetref", "_noderref"], name: "_documen951_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr951", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_documen951_bynodemsg_rnr", unique: true, using: :btree

  create_table "_documentchngr989", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_documentchngr989", ["_idrref", "_nodetref", "_noderref"], name: "_documen989_bydatakey_rr", unique: true, using: :btree
  add_index "_documentchngr989", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_documen989_bynodemsg_rnr", unique: true, using: :btree

  create_table "_enum100", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum100", ["_enumorder", "_idrref"], name: "_enum100_byorder_nr", unique: true, using: :btree

  create_table "_enum101", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum101", ["_enumorder", "_idrref"], name: "_enum101_byorder_nr", unique: true, using: :btree

  create_table "_enum102", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum102", ["_enumorder", "_idrref"], name: "_enum102_byorder_nr", unique: true, using: :btree

  create_table "_enum103", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum103", ["_enumorder", "_idrref"], name: "_enum103_byorder_nr", unique: true, using: :btree

  create_table "_enum104", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum104", ["_enumorder", "_idrref"], name: "_enum104_byorder_nr", unique: true, using: :btree

  create_table "_enum105", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum105", ["_enumorder", "_idrref"], name: "_enum105_byorder_nr", unique: true, using: :btree

  create_table "_enum106", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum106", ["_enumorder", "_idrref"], name: "_enum106_byorder_nr", unique: true, using: :btree

  create_table "_enum107", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum107", ["_enumorder", "_idrref"], name: "_enum107_byorder_nr", unique: true, using: :btree

  create_table "_enum108", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum108", ["_enumorder", "_idrref"], name: "_enum108_byorder_nr", unique: true, using: :btree

  create_table "_enum109", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum109", ["_enumorder", "_idrref"], name: "_enum109_byorder_nr", unique: true, using: :btree

  create_table "_enum110", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum110", ["_enumorder", "_idrref"], name: "_enum110_byorder_nr", unique: true, using: :btree

  create_table "_enum111", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum111", ["_enumorder", "_idrref"], name: "_enum111_byorder_nr", unique: true, using: :btree

  create_table "_enum112", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum112", ["_enumorder", "_idrref"], name: "_enum112_byorder_nr", unique: true, using: :btree

  create_table "_enum113", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum113", ["_enumorder", "_idrref"], name: "_enum113_byorder_nr", unique: true, using: :btree

  create_table "_enum114", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum114", ["_enumorder", "_idrref"], name: "_enum114_byorder_nr", unique: true, using: :btree

  create_table "_enum115", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum115", ["_enumorder", "_idrref"], name: "_enum115_byorder_nr", unique: true, using: :btree

  create_table "_enum116", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum116", ["_enumorder", "_idrref"], name: "_enum116_byorder_nr", unique: true, using: :btree

  create_table "_enum117", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum117", ["_enumorder", "_idrref"], name: "_enum117_byorder_nr", unique: true, using: :btree

  create_table "_enum118", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum118", ["_enumorder", "_idrref"], name: "_enum118_byorder_nr", unique: true, using: :btree

  create_table "_enum119", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum119", ["_enumorder", "_idrref"], name: "_enum119_byorder_nr", unique: true, using: :btree

  create_table "_enum120", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum120", ["_enumorder", "_idrref"], name: "_enum120_byorder_nr", unique: true, using: :btree

  create_table "_enum121", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum121", ["_enumorder", "_idrref"], name: "_enum121_byorder_nr", unique: true, using: :btree

  create_table "_enum122", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum122", ["_enumorder", "_idrref"], name: "_enum122_byorder_nr", unique: true, using: :btree

  create_table "_enum123", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum123", ["_enumorder", "_idrref"], name: "_enum123_byorder_nr", unique: true, using: :btree

  create_table "_enum124", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum124", ["_enumorder", "_idrref"], name: "_enum124_byorder_nr", unique: true, using: :btree

  create_table "_enum125", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum125", ["_enumorder", "_idrref"], name: "_enum125_byorder_nr", unique: true, using: :btree

  create_table "_enum126", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum126", ["_enumorder", "_idrref"], name: "_enum126_byorder_nr", unique: true, using: :btree

  create_table "_enum77", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum77", ["_enumorder", "_idrref"], name: "_enum77_byorder_nr", unique: true, using: :btree

  create_table "_enum78", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum78", ["_enumorder", "_idrref"], name: "_enum78_byorder_nr", unique: true, using: :btree

  create_table "_enum79", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum79", ["_enumorder", "_idrref"], name: "_enum79_byorder_nr", unique: true, using: :btree

  create_table "_enum80", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum80", ["_enumorder", "_idrref"], name: "_enum80_byorder_nr", unique: true, using: :btree

  create_table "_enum81", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum81", ["_enumorder", "_idrref"], name: "_enum81_byorder_nr", unique: true, using: :btree

  create_table "_enum82", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum82", ["_enumorder", "_idrref"], name: "_enum82_byorder_nr", unique: true, using: :btree

  create_table "_enum83", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum83", ["_enumorder", "_idrref"], name: "_enum83_byorder_nr", unique: true, using: :btree

  create_table "_enum84", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum84", ["_enumorder", "_idrref"], name: "_enum84_byorder_nr", unique: true, using: :btree

  create_table "_enum85", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum85", ["_enumorder", "_idrref"], name: "_enum85_byorder_nr", unique: true, using: :btree

  create_table "_enum86", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum86", ["_enumorder", "_idrref"], name: "_enum86_byorder_nr", unique: true, using: :btree

  create_table "_enum87", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum87", ["_enumorder", "_idrref"], name: "_enum87_byorder_nr", unique: true, using: :btree

  create_table "_enum88", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum88", ["_enumorder", "_idrref"], name: "_enum88_byorder_nr", unique: true, using: :btree

  create_table "_enum89", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum89", ["_enumorder", "_idrref"], name: "_enum89_byorder_nr", unique: true, using: :btree

  create_table "_enum90", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum90", ["_enumorder", "_idrref"], name: "_enum90_byorder_nr", unique: true, using: :btree

  create_table "_enum91", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum91", ["_enumorder", "_idrref"], name: "_enum91_byorder_nr", unique: true, using: :btree

  create_table "_enum92", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum92", ["_enumorder", "_idrref"], name: "_enum92_byorder_nr", unique: true, using: :btree

  create_table "_enum93", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum93", ["_enumorder", "_idrref"], name: "_enum93_byorder_nr", unique: true, using: :btree

  create_table "_enum94", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum94", ["_enumorder", "_idrref"], name: "_enum94_byorder_nr", unique: true, using: :btree

  create_table "_enum95", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum95", ["_enumorder", "_idrref"], name: "_enum95_byorder_nr", unique: true, using: :btree

  create_table "_enum96", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum96", ["_enumorder", "_idrref"], name: "_enum96_byorder_nr", unique: true, using: :btree

  create_table "_enum97", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum97", ["_enumorder", "_idrref"], name: "_enum97_byorder_nr", unique: true, using: :btree

  create_table "_enum98", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum98", ["_enumorder", "_idrref"], name: "_enum98_byorder_nr", unique: true, using: :btree

  create_table "_enum99", primary_key: "_idrref", force: :cascade do |t|
    t.decimal "_enumorder", precision: 10, null: false
  end

  add_index "_enum99", ["_enumorder", "_idrref"], name: "_enum99_byorder_nr", unique: true, using: :btree

  create_table "_inforg1232", id: false, force: :cascade do |t|
    t.datetime "_period",                     null: false
    t.binary   "_recordertref",               null: false
    t.binary   "_recorderrref",               null: false
    t.decimal  "_lineno",       precision: 9, null: false
    t.boolean  "_active",                     null: false
    t.binary   "_fld1233rref",                null: false
    t.datetime "_fld1234",                    null: false
    t.datetime "_fld1235",                    null: false
    t.datetime "_fld1236",                    null: false
    t.datetime "_fld1237",                    null: false
  end

  add_index "_inforg1232", ["_fld1233rref", "_period", "_recordertref", "_recorderrref", "_lineno"], name: "_inforg1232_bydims_rtrn", unique: true, using: :btree
  add_index "_inforg1232", ["_period", "_recordertref", "_recorderrref", "_lineno"], name: "_inforg1232_byperiod_trn", unique: true, using: :btree
  add_index "_inforg1232", ["_recordertref", "_recorderrref", "_lineno"], name: "_inforg1232_byrecorder_rn", unique: true, using: :btree

  create_table "_inforg1239", id: false, force: :cascade do |t|
    t.datetime "_period",                     null: false
    t.binary   "_recorderrref",               null: false
    t.decimal  "_lineno",       precision: 9, null: false
    t.boolean  "_active",                     null: false
    t.binary   "_fld1240rref",                null: false
    t.binary   "_fld1241rref",                null: false
    t.binary   "_fld1242rref",                null: false
    t.binary   "_fld1243rref",                null: false
  end

  add_index "_inforg1239", ["_fld1240rref", "_period"], name: "_inforg1239_bydims_rt", using: :btree
  add_index "_inforg1239", ["_period", "_fld1240rref"], name: "_inforg1239_byperiod_tr", using: :btree
  add_index "_inforg1239", ["_recorderrref", "_lineno"], name: "_inforg1239_byrecorder_rn", unique: true, using: :btree

  create_table "_inforg1268", id: false, force: :cascade do |t|
    t.decimal "_fld1269",     precision: 10, null: false
    t.binary  "_fld1270rref",                null: false
  end

  add_index "_inforg1268", ["_fld1269"], name: "_inforg1268_bydims_n", unique: true, using: :btree
  add_index "_inforg1268", ["_fld1270rref", "_fld1269"], name: "_inforg1268_byresource1271_rn", unique: true, using: :btree

  create_table "_inforg1347", id: false, force: :cascade do |t|
    t.binary  "_fld1348_type",                 null: false
    t.binary  "_fld1348_rtref",                null: false
    t.binary  "_fld1348_rrref",                null: false
    t.boolean "_fld1349",                      null: false
    t.boolean "_fld1350",                      null: false
    t.decimal "_fld1351",       precision: 10, null: false
  end

  add_index "_inforg1347", ["_fld1348_type", "_fld1348_rtref", "_fld1348_rrref"], name: "_inforg1347_bydims_r", unique: true, using: :btree

  create_table "_inforg1352", id: false, force: :cascade do |t|
    t.binary "_fld1353_type",  null: false
    t.binary "_fld1353_rtref", null: false
    t.binary "_fld1353_rrref", null: false
    t.binary "_fld1354_type",  null: false
    t.binary "_fld1354_rtref", null: false
    t.binary "_fld1354_rrref", null: false
  end

  add_index "_inforg1352", ["_fld1353_type", "_fld1353_rtref", "_fld1353_rrref"], name: "_inforg1352_bydims_r", unique: true, using: :btree
  add_index "_inforg1352", ["_fld1354_type", "_fld1354_rtref", "_fld1354_rrref", "_fld1353_type", "_fld1353_rtref", "_fld1353_rrref"], name: "_inforg1352_byresource1355_rr", unique: true, using: :btree

  create_table "_inforg1372", id: false, force: :cascade do |t|
    t.binary   "_fld1373_type",  null: false
    t.binary   "_fld1373_rtref", null: false
    t.binary   "_fld1373_rrref", null: false
    t.datetime "_fld1374",       null: false
    t.datetime "_fld1375",       null: false
    t.boolean  "_fld1376",       null: false
    t.boolean  "_fld1377",       null: false
  end

  add_index "_inforg1372", ["_fld1373_type", "_fld1373_rtref", "_fld1373_rrref"], name: "_inforg1372_bydims_r", unique: true, using: :btree

  create_table "_inforg1392", id: false, force: :cascade do |t|
    t.datetime "_period",                               null: false
    t.binary   "_fld1393rref",                          null: false
    t.binary   "_fld1394rref",                          null: false
    t.decimal  "_fld1395",     precision: 15, scale: 2, null: false
  end

  add_index "_inforg1392", ["_fld1393rref", "_fld1394rref", "_period"], name: "_inforg1392_bydims_rrt", unique: true, using: :btree
  add_index "_inforg1392", ["_fld1393rref", "_period", "_fld1394rref"], name: "_inforg1392_bydims1396_rtr", unique: true, using: :btree
  add_index "_inforg1392", ["_period", "_fld1393rref", "_fld1394rref"], name: "_inforg1392_byperiod_trr", unique: true, using: :btree

  create_table "_inforg1398", id: false, force: :cascade do |t|
    t.datetime "_period",                                null: false
    t.binary   "_recordertref",                          null: false
    t.binary   "_recorderrref",                          null: false
    t.decimal  "_lineno",       precision: 9,            null: false
    t.boolean  "_active",                                null: false
    t.binary   "_fld1399rref",                           null: false
    t.binary   "_fld1400rref",                           null: false
    t.decimal  "_fld1401",      precision: 15, scale: 2, null: false
    t.binary   "_fld1402rref",                           null: false
    t.decimal  "_fld1403",      precision: 5,  scale: 2, null: false
    t.decimal  "_fld1404",      precision: 5,  scale: 2, null: false
    t.datetime "_fld1405",                               null: false
    t.binary   "_fld1406rref",                           null: false
  end

  add_index "_inforg1398", ["_fld1399rref", "_fld1400rref", "_fld1401", "_fld1402rref", "_period"], name: "_inforg1398_bydims_rrnrt", using: :btree
  add_index "_inforg1398", ["_fld1402rref", "_period", "_fld1399rref", "_fld1400rref", "_fld1401"], name: "_inforg1398_bydims1407_rtrrn", using: :btree
  add_index "_inforg1398", ["_period", "_fld1399rref", "_fld1400rref", "_fld1401", "_fld1402rref"], name: "_inforg1398_byperiod_trrnr", using: :btree
  add_index "_inforg1398", ["_recordertref", "_recorderrref", "_lineno"], name: "_inforg1398_byrecorder_rn", unique: true, using: :btree

  create_table "_inforg1426", id: false, force: :cascade do |t|
    t.binary   "_fld1427_type",  null: false
    t.binary   "_fld1427_rtref", null: false
    t.binary   "_fld1427_rrref", null: false
    t.binary   "_fld1428rref",   null: false
    t.binary   "_fld1429rref",   null: false
    t.datetime "_fld1430",       null: false
    t.datetime "_fld1431",       null: false
    t.binary   "_simplekey",     null: false
  end

  add_index "_inforg1426", ["_fld1427_type", "_fld1427_rtref", "_fld1427_rrref", "_fld1428rref"], name: "_inforg1426_bydims_rr", unique: true, using: :btree
  add_index "_inforg1426", ["_simplekey"], name: "_inforg1426_bysimplekey_b", unique: true, using: :btree

  create_table "_inforg1432", id: false, force: :cascade do |t|
    t.binary   "_fld1433_type",  null: false
    t.binary   "_fld1433_rtref", null: false
    t.binary   "_fld1433_rrref", null: false
    t.binary   "_fld1434rref",   null: false
    t.datetime "_fld1435",       null: false
    t.binary   "_simplekey",     null: false
  end

  add_index "_inforg1432", ["_fld1433_type", "_fld1433_rtref", "_fld1433_rrref", "_fld1434rref"], name: "_inforg1432_bydims_rr", unique: true, using: :btree
  add_index "_inforg1432", ["_simplekey"], name: "_inforg1432_bysimplekey_b", unique: true, using: :btree

  create_table "_inforg1436", id: false, force: :cascade do |t|
    t.binary  "_fld1437rref",                          null: false
    t.decimal "_fld1438",     precision: 15,           null: false
    t.decimal "_fld1439",     precision: 5,  scale: 1, null: false
    t.binary  "_simplekey",                            null: false
  end

  add_index "_inforg1436", ["_fld1437rref", "_fld1438"], name: "_inforg1436_bydims_rn", unique: true, using: :btree
  add_index "_inforg1436", ["_simplekey"], name: "_inforg1436_bysimplekey_b", unique: true, using: :btree

  create_table "_inforg1441", id: false, force: :cascade do |t|
    t.decimal "_fld1442",     precision: 11, null: false
    t.binary  "_fld1443rref",                null: false
  end

  add_index "_inforg1441", ["_fld1442"], name: "_inforg1441_bydims_n", unique: true, using: :btree

  create_table "_inforg1466", id: false, force: :cascade do |t|
    t.datetime "_period",      null: false
    t.binary   "_fld1467rref", null: false
    t.boolean  "_fld1468",     null: false
    t.binary   "_fld1469rref", null: false
    t.boolean  "_fld1470",     null: false
    t.boolean  "_fld1471",     null: false
  end

  add_index "_inforg1466", ["_fld1467rref", "_period"], name: "_inforg1466_bydims_rt", unique: true, using: :btree
  add_index "_inforg1466", ["_fld1469rref", "_period", "_fld1467rref"], name: "_inforg1466_byresource1472_rtr", unique: true, using: :btree
  add_index "_inforg1466", ["_fld1470", "_period", "_fld1467rref"], name: "_inforg1466_byresource1473_ltr", unique: true, using: :btree
  add_index "_inforg1466", ["_period", "_fld1467rref"], name: "_inforg1466_byperiod_tr", unique: true, using: :btree

  create_table "_inforg1475", id: false, force: :cascade do |t|
    t.datetime "_period",                                null: false
    t.binary   "_recordertref",                          null: false
    t.binary   "_recorderrref",                          null: false
    t.decimal  "_lineno",       precision: 9,            null: false
    t.boolean  "_active",                                null: false
    t.binary   "_fld1476rref",                           null: false
    t.binary   "_fld1477rref",                           null: false
    t.binary   "_fld1478rref",                           null: false
    t.decimal  "_fld1479",      precision: 15, scale: 2, null: false
    t.binary   "_fld1480rref",                           null: false
    t.decimal  "_fld1481",      precision: 10, scale: 2, null: false
  end

  add_index "_inforg1475", ["_fld1476rref", "_fld1477rref", "_fld1478rref", "_period", "_recordertref", "_recorderrref", "_lineno"], name: "_inforg1475_bydims_rrrtrn", unique: true, using: :btree
  add_index "_inforg1475", ["_fld1476rref", "_period", "_recordertref", "_recorderrref", "_lineno"], name: "_inforg1475_bydims1482_rtrn", unique: true, using: :btree
  add_index "_inforg1475", ["_fld1477rref", "_period", "_recordertref", "_recorderrref", "_lineno"], name: "_inforg1475_bydims1483_rtrn", unique: true, using: :btree
  add_index "_inforg1475", ["_period", "_recordertref", "_recorderrref", "_lineno"], name: "_inforg1475_byperiod_trn", unique: true, using: :btree
  add_index "_inforg1475", ["_recordertref", "_recorderrref", "_lineno"], name: "_inforg1475_byrecorder_rn", unique: true, using: :btree

  create_table "_inforgchngr1224", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.decimal "_fld1204",   precision: 1
    t.decimal "_fld1205",   precision: 2
    t.decimal "_fld1206",   precision: 25
    t.decimal "_fld1207",   precision: 3
    t.decimal "_fld1208",   precision: 3
    t.decimal "_fld1209",   precision: 3
    t.decimal "_fld1210",   precision: 4
  end

  add_index "_inforgchngr1224", ["_fld1204", "_fld1205", "_fld1206", "_fld1207", "_fld1208", "_fld1209", "_fld1210", "_nodetref", "_noderref"], name: "_inforg1224_bydatakey_nnnnnnnr", unique: true, using: :btree
  add_index "_inforgchngr1224", ["_nodetref", "_noderref", "_messageno", "_fld1204", "_fld1205", "_fld1206", "_fld1207", "_fld1208", "_fld1209", "_fld1210"], name: "_inforg1224_bynodemsg_rnnnnnnnn", unique: true, using: :btree

  create_table "_inforgchngr1238", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                    null: false
    t.binary  "_noderref",                    null: false
    t.decimal "_messageno",    precision: 10
    t.binary  "_recordertref",                null: false
    t.binary  "_recorderrref",                null: false
  end

  add_index "_inforgchngr1238", ["_nodetref", "_noderref", "_messageno", "_recordertref", "_recorderrref"], name: "_inforg1238_bynodemsg_rnr", unique: true, using: :btree
  add_index "_inforgchngr1238", ["_recordertref", "_recorderrref", "_nodetref", "_noderref"], name: "_inforg1238_bydatakey_rr", unique: true, using: :btree

  create_table "_inforgchngr1262", id: false, force: :cascade do |t|
    t.binary   "_nodetref",                     null: false
    t.binary   "_noderref",                     null: false
    t.decimal  "_messageno",     precision: 10
    t.datetime "_period"
    t.binary   "_fld1245_type"
    t.binary   "_fld1245_rtref"
    t.binary   "_fld1245_rrref"
    t.boolean  "_fld1246"
  end

  add_index "_inforgchngr1262", ["_nodetref", "_noderref", "_messageno", "_period", "_fld1245_type", "_fld1245_rtref", "_fld1245_rrref", "_fld1246"], name: "_inforg1262_bynodemsg_rntrl", unique: true, using: :btree
  add_index "_inforgchngr1262", ["_period", "_fld1245_type", "_fld1245_rtref", "_fld1245_rrref", "_fld1246", "_nodetref", "_noderref"], name: "_inforg1262_bydatakey_trlr", unique: true, using: :btree

  create_table "_inforgchngr1267", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                   null: false
    t.binary  "_noderref",                   null: false
    t.decimal "_messageno",   precision: 10
    t.binary  "_fld1264rref"
  end

  add_index "_inforgchngr1267", ["_fld1264rref", "_nodetref", "_noderref"], name: "_inforg1267_bydatakey_rr", unique: true, using: :btree
  add_index "_inforgchngr1267", ["_nodetref", "_noderref", "_messageno", "_fld1264rref"], name: "_inforg1267_bynodemsg_rnr", unique: true, using: :btree

  create_table "_inforgchngr1272", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.decimal "_fld1269",   precision: 10
  end

  add_index "_inforgchngr1272", ["_fld1269", "_nodetref", "_noderref"], name: "_inforg1272_bydatakey_nr", unique: true, using: :btree
  add_index "_inforgchngr1272", ["_nodetref", "_noderref", "_messageno", "_fld1269"], name: "_inforg1272_bynodemsg_rnn", unique: true, using: :btree

  create_table "_inforgchngr1307", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                   null: false
    t.binary  "_noderref",                   null: false
    t.decimal "_messageno",   precision: 10
    t.binary  "_fld1287rref"
    t.decimal "_fld1288",     precision: 2
  end

  add_index "_inforgchngr1307", ["_fld1287rref", "_fld1288", "_nodetref", "_noderref"], name: "_inforg1307_bydatakey_rnr", unique: true, using: :btree
  add_index "_inforgchngr1307", ["_nodetref", "_noderref", "_messageno", "_fld1287rref", "_fld1288"], name: "_inforg1307_bynodemsg_rnrn", unique: true, using: :btree

  create_table "_inforgchngr1313", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                   null: false
    t.binary  "_noderref",                   null: false
    t.decimal "_messageno",   precision: 10
    t.binary  "_fld1309rref"
    t.binary  "_fld1310rref"
  end

  add_index "_inforgchngr1313", ["_fld1309rref", "_fld1310rref", "_nodetref", "_noderref"], name: "_inforg1313_bydatakey_rrr", unique: true, using: :btree
  add_index "_inforgchngr1313", ["_nodetref", "_noderref", "_messageno", "_fld1309rref", "_fld1310rref"], name: "_inforg1313_bynodemsg_rnrr", unique: true, using: :btree

  create_table "_inforgchngr1361", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                    null: false
    t.binary  "_noderref",                    null: false
    t.decimal "_messageno",    precision: 10
    t.binary  "_recordertref",                null: false
    t.binary  "_recorderrref",                null: false
  end

  add_index "_inforgchngr1361", ["_nodetref", "_noderref", "_messageno", "_recordertref", "_recorderrref"], name: "_inforg1361_bynodemsg_rnr", unique: true, using: :btree
  add_index "_inforgchngr1361", ["_recordertref", "_recorderrref", "_nodetref", "_noderref"], name: "_inforg1361_bydatakey_rr", unique: true, using: :btree

  create_table "_inforgchngr1371", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                     null: false
    t.binary  "_noderref",                     null: false
    t.decimal "_messageno",     precision: 10
    t.binary  "_fld1363_type"
    t.binary  "_fld1363_rtref"
    t.binary  "_fld1363_rrref"
    t.binary  "_fld1364_type"
    t.binary  "_fld1364_rtref"
    t.binary  "_fld1364_rrref"
  end

  add_index "_inforgchngr1371", ["_fld1363_type", "_fld1363_rtref", "_fld1363_rrref", "_fld1364_type", "_fld1364_rtref", "_fld1364_rrref", "_nodetref", "_noderref"], name: "_inforg1371_bydatakey_rrr", unique: true, using: :btree
  add_index "_inforgchngr1371", ["_nodetref", "_noderref", "_messageno", "_fld1363_type", "_fld1363_rtref", "_fld1363_rrref", "_fld1364_type", "_fld1364_rtref", "_fld1364_rrref"], name: "_inforg1371_bynodemsg_rnrr", unique: true, using: :btree

  create_table "_inforgchngr1397", id: false, force: :cascade do |t|
    t.binary   "_nodetref",                   null: false
    t.binary   "_noderref",                   null: false
    t.decimal  "_messageno",   precision: 10
    t.datetime "_period"
    t.binary   "_fld1393rref"
    t.binary   "_fld1394rref"
  end

  add_index "_inforgchngr1397", ["_nodetref", "_noderref", "_messageno", "_period", "_fld1393rref", "_fld1394rref"], name: "_inforg1397_bynodemsg_rntrr", unique: true, using: :btree
  add_index "_inforgchngr1397", ["_period", "_fld1393rref", "_fld1394rref", "_nodetref", "_noderref"], name: "_inforg1397_bydatakey_trrr", unique: true, using: :btree

  create_table "_inforgchngr1408", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                    null: false
    t.binary  "_noderref",                    null: false
    t.decimal "_messageno",    precision: 10
    t.binary  "_recordertref",                null: false
    t.binary  "_recorderrref",                null: false
  end

  add_index "_inforgchngr1408", ["_nodetref", "_noderref", "_messageno", "_recordertref", "_recorderrref"], name: "_inforg1408_bynodemsg_rnr", unique: true, using: :btree
  add_index "_inforgchngr1408", ["_recordertref", "_recorderrref", "_nodetref", "_noderref"], name: "_inforg1408_bydatakey_rr", unique: true, using: :btree

  create_table "_inforgchngr1440", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                   null: false
    t.binary  "_noderref",                   null: false
    t.decimal "_messageno",   precision: 10
    t.binary  "_fld1437rref"
    t.decimal "_fld1438",     precision: 15
  end

  add_index "_inforgchngr1440", ["_fld1437rref", "_fld1438", "_nodetref", "_noderref"], name: "_inforg1440_bydatakey_rnr", unique: true, using: :btree
  add_index "_inforgchngr1440", ["_nodetref", "_noderref", "_messageno", "_fld1437rref", "_fld1438"], name: "_inforg1440_bynodemsg_rnrn", unique: true, using: :btree

  create_table "_inforgchngr1444", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.decimal "_fld1442",   precision: 11
  end

  add_index "_inforgchngr1444", ["_fld1442", "_nodetref", "_noderref"], name: "_inforg1444_bydatakey_nr", unique: true, using: :btree
  add_index "_inforgchngr1444", ["_nodetref", "_noderref", "_messageno", "_fld1442"], name: "_inforg1444_bynodemsg_rnn", unique: true, using: :btree

  create_table "_inforgchngr1474", id: false, force: :cascade do |t|
    t.binary   "_nodetref",                   null: false
    t.binary   "_noderref",                   null: false
    t.decimal  "_messageno",   precision: 10
    t.datetime "_period"
    t.binary   "_fld1467rref"
  end

  add_index "_inforgchngr1474", ["_nodetref", "_noderref", "_messageno", "_period", "_fld1467rref"], name: "_inforg1474_bynodemsg_rntr", unique: true, using: :btree
  add_index "_inforgchngr1474", ["_period", "_fld1467rref", "_nodetref", "_noderref"], name: "_inforg1474_bydatakey_trr", unique: true, using: :btree

  create_table "_inforgchngr1484", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                    null: false
    t.binary  "_noderref",                    null: false
    t.decimal "_messageno",    precision: 10
    t.binary  "_recordertref",                null: false
    t.binary  "_recorderrref",                null: false
  end

  add_index "_inforgchngr1484", ["_nodetref", "_noderref", "_messageno", "_recordertref", "_recorderrref"], name: "_inforg1484_bynodemsg_rnr", unique: true, using: :btree
  add_index "_inforgchngr1484", ["_recordertref", "_recorderrref", "_nodetref", "_noderref"], name: "_inforg1484_bydatakey_rr", unique: true, using: :btree

  create_table "_inforgchngr1493", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.decimal "_fld1486",   precision: 10
  end

  add_index "_inforgchngr1493", ["_fld1486", "_nodetref", "_noderref"], name: "_inforg1493_bydatakey_nr", unique: true, using: :btree
  add_index "_inforgchngr1493", ["_nodetref", "_noderref", "_messageno", "_fld1486"], name: "_inforg1493_bynodemsg_rnn", unique: true, using: :btree

  create_table "_reference18_vt183", id: false, force: :cascade do |t|
    t.binary  "_reference18_idrref",               null: false
    t.binary  "_keyfield",                         null: false
    t.decimal "_lineno184",          precision: 5, null: false
    t.binary  "_fld185rref",                       null: false
    t.binary  "_fld186rref",                       null: false
  end

  add_index "_reference18_vt183", ["_fld185rref", "_reference18_idrref"], name: "_referenc18_vt183_byfield187_rr", using: :btree
  add_index "_reference18_vt183", ["_reference18_idrref", "_keyfield"], name: "_referenc18_vt183_intkeyind", unique: true, using: :btree

  create_table "_reference20_vt325", id: false, force: :cascade do |t|
    t.binary  "_reference20_idrref",                         null: false
    t.binary  "_keyfield",                                   null: false
    t.decimal "_lineno326",          precision: 5,           null: false
    t.binary  "_fld327rref",                                 null: false
    t.decimal "_fld328",             precision: 5, scale: 2, null: false
  end

  add_index "_reference20_vt325", ["_reference20_idrref", "_keyfield"], name: "_referenc20_vt325_intkeyind", unique: true, using: :btree

  create_table "_reference20_vt329", id: false, force: :cascade do |t|
    t.binary  "_reference20_idrref",                          null: false
    t.binary  "_keyfield",                                    null: false
    t.decimal "_lineno330",          precision: 5,            null: false
    t.binary  "_fld331rref",                                  null: false
    t.binary  "_fld332rref",                                  null: false
    t.decimal "_fld333",             precision: 10, scale: 2, null: false
    t.boolean "_fld334",                                      null: false
  end

  add_index "_reference20_vt329", ["_reference20_idrref", "_keyfield"], name: "_referenc20_vt329_intkeyind", unique: true, using: :btree

  create_table "_reference20_vt335", id: false, force: :cascade do |t|
    t.binary  "_reference20_idrref",                null: false
    t.binary  "_keyfield",                          null: false
    t.decimal "_lineno336",          precision: 5,  null: false
    t.binary  "_fld337rref",                        null: false
    t.binary  "_fld338rref",                        null: false
    t.decimal "_fld339",             precision: 10, null: false
    t.binary  "_fld340rref",                        null: false
    t.boolean "_fld341",                            null: false
  end

  add_index "_reference20_vt335", ["_reference20_idrref", "_keyfield"], name: "_referenc20_vt335_intkeyind", unique: true, using: :btree

  create_table "_reference24_vt365", id: false, force: :cascade do |t|
    t.binary  "_reference24_idrref",                          null: false
    t.binary  "_keyfield",                                    null: false
    t.decimal "_lineno366",          precision: 5,            null: false
    t.binary  "_fld367rref",                                  null: false
    t.binary  "_fld368rref",                                  null: false
    t.binary  "_fld369rref",                                  null: false
    t.decimal "_fld370",             precision: 10, scale: 3, null: false
    t.decimal "_fld371",             precision: 15, scale: 3, null: false
    t.decimal "_fld372",             precision: 15, scale: 3, null: false
    t.decimal "_fld373",             precision: 5,  scale: 2, null: false
    t.decimal "_fld374",             precision: 5,  scale: 2, null: false
    t.decimal "_fld375",             precision: 18, scale: 6, null: false
    t.boolean "_fld376",                                      null: false
  end

  add_index "_reference24_vt365", ["_reference24_idrref", "_keyfield"], name: "_referenc24_vt365_intkeyind", unique: true, using: :btree

  create_table "_reference24_vt377", id: false, force: :cascade do |t|
    t.binary  "_reference24_idrref",                          null: false
    t.binary  "_keyfield",                                    null: false
    t.decimal "_lineno378",          precision: 5,            null: false
    t.binary  "_fld379rref",                                  null: false
    t.binary  "_fld380rref",                                  null: false
    t.decimal "_fld381",             precision: 15, scale: 3, null: false
    t.decimal "_fld382",             precision: 15, scale: 3, null: false
    t.binary  "_fld383rref",                                  null: false
    t.decimal "_fld384",             precision: 3,            null: false
    t.boolean "_fld385",                                      null: false
  end

  add_index "_reference24_vt377", ["_reference24_idrref", "_keyfield"], name: "_referenc24_vt377_intkeyind", unique: true, using: :btree

  create_table "_reference28_vt419", id: false, force: :cascade do |t|
    t.binary   "_reference28_idrref",               null: false
    t.binary   "_keyfield",                         null: false
    t.decimal  "_lineno420",          precision: 5, null: false
    t.boolean  "_fld421",                           null: false
    t.binary   "_fld422rref",                       null: false
    t.datetime "_fld423",                           null: false
    t.datetime "_fld424",                           null: false
  end

  add_index "_reference28_vt419", ["_reference28_idrref", "_keyfield"], name: "_referenc28_vt419_intkeyind", unique: true, using: :btree

  create_table "_reference30_vt440", id: false, force: :cascade do |t|
    t.binary  "_reference30_idrref",               null: false
    t.binary  "_keyfield",                         null: false
    t.decimal "_lineno441",          precision: 5, null: false
    t.binary  "_fld442rref",                       null: false
  end

  add_index "_reference30_vt440", ["_reference30_idrref", "_keyfield"], name: "_referenc30_vt440_intkeyind", unique: true, using: :btree

  create_table "_reference34_vt453", id: false, force: :cascade do |t|
    t.binary  "_reference34_idrref",                null: false
    t.binary  "_keyfield",                          null: false
    t.decimal "_lineno454",          precision: 5,  null: false
    t.binary  "_fld455_type",                       null: false
    t.binary  "_fld455_rtref",                      null: false
    t.binary  "_fld455_rrref",                      null: false
    t.binary  "_fld456rref",                        null: false
    t.binary  "_fld457rref",                        null: false
    t.decimal "_fld458",             precision: 10, null: false
  end

  add_index "_reference34_vt453", ["_reference34_idrref", "_keyfield"], name: "_referenc34_vt453_intkeyind", unique: true, using: :btree

  create_table "_reference41_vt489", id: false, force: :cascade do |t|
    t.binary  "_reference41_idrref",                         null: false
    t.binary  "_keyfield",                                   null: false
    t.decimal "_lineno490",          precision: 5,           null: false
    t.binary  "_fld491rref",                                 null: false
    t.decimal "_fld492",             precision: 5, scale: 2, null: false
  end

  add_index "_reference41_vt489", ["_reference41_idrref", "_keyfield"], name: "_referenc41_vt489_intkeyind", unique: true, using: :btree

  create_table "_reference48_vt506", id: false, force: :cascade do |t|
    t.binary  "_reference48_idrref",                          null: false
    t.binary  "_keyfield",                                    null: false
    t.decimal "_lineno507",          precision: 5,            null: false
    t.decimal "_fld508",             precision: 15,           null: false
    t.decimal "_fld509",             precision: 15,           null: false
    t.decimal "_fld510",             precision: 5,  scale: 1, null: false
  end

  add_index "_reference48_vt506", ["_reference48_idrref", "_keyfield"], name: "_referenc48_vt506_intkeyind", unique: true, using: :btree

  create_table "_reference49_vt531", id: false, force: :cascade do |t|
    t.binary   "_reference49_idrref",               null: false
    t.binary   "_keyfield",                         null: false
    t.decimal  "_lineno532",          precision: 5, null: false
    t.boolean  "_fld533",                           null: false
    t.binary   "_fld534rref",                       null: false
    t.datetime "_fld535",                           null: false
    t.datetime "_fld536",                           null: false
  end

  add_index "_reference49_vt531", ["_reference49_idrref", "_keyfield"], name: "_referenc49_vt531_intkeyind", unique: true, using: :btree

  create_table "_reference49_vt537", id: false, force: :cascade do |t|
    t.binary  "_reference49_idrref",               null: false
    t.binary  "_keyfield",                         null: false
    t.decimal "_lineno538",          precision: 5, null: false
    t.binary  "_fld539rref",                       null: false
    t.binary  "_fld540rref",                       null: false
    t.boolean "_fld541",                           null: false
    t.boolean "_fld542",                           null: false
    t.boolean "_fld543",                           null: false
  end

  add_index "_reference49_vt537", ["_reference49_idrref", "_keyfield"], name: "_referenc49_vt537_intkeyind", unique: true, using: :btree

  create_table "_referencechngr137", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr137", ["_idrref", "_nodetref", "_noderref"], name: "_referen137_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr137", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen137_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr147", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr147", ["_idrref", "_nodetref", "_noderref"], name: "_referen147_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr147", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen147_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr149", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr149", ["_idrref", "_nodetref", "_noderref"], name: "_referen149_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr149", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen149_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr151", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr151", ["_idrref", "_nodetref", "_noderref"], name: "_referen151_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr151", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen151_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr153", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr153", ["_idrref", "_nodetref", "_noderref"], name: "_referen153_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr153", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen153_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr168", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr168", ["_idrref", "_nodetref", "_noderref"], name: "_referen168_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr168", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen168_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr342", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr342", ["_idrref", "_nodetref", "_noderref"], name: "_referen342_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr342", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen342_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr356", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr356", ["_idrref", "_nodetref", "_noderref"], name: "_referen356_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr356", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen356_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr388", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr388", ["_idrref", "_nodetref", "_noderref"], name: "_referen388_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr388", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen388_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr396", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr396", ["_idrref", "_nodetref", "_noderref"], name: "_referen396_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr396", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen396_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr401", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr401", ["_idrref", "_nodetref", "_noderref"], name: "_referen401_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr401", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen401_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr425", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr425", ["_idrref", "_nodetref", "_noderref"], name: "_referen425_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr425", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen425_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr433", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr433", ["_idrref", "_nodetref", "_noderref"], name: "_referen433_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr433", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen433_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr443", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr443", ["_idrref", "_nodetref", "_noderref"], name: "_referen443_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr443", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen443_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr449", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr449", ["_idrref", "_nodetref", "_noderref"], name: "_referen449_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr449", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen449_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr466", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr466", ["_idrref", "_nodetref", "_noderref"], name: "_referen466_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr466", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen466_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr472", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr472", ["_idrref", "_nodetref", "_noderref"], name: "_referen472_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr472", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen472_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr479", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr479", ["_idrref", "_nodetref", "_noderref"], name: "_referen479_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr479", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen479_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr484", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr484", ["_idrref", "_nodetref", "_noderref"], name: "_referen484_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr484", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen484_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr485", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr485", ["_idrref", "_nodetref", "_noderref"], name: "_referen485_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr485", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen485_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr493", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr493", ["_idrref", "_nodetref", "_noderref"], name: "_referen493_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr493", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen493_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr497", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr497", ["_idrref", "_nodetref", "_noderref"], name: "_referen497_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr497", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen497_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr501", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr501", ["_idrref", "_nodetref", "_noderref"], name: "_referen501_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr501", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen501_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr502", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr502", ["_idrref", "_nodetref", "_noderref"], name: "_referen502_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr502", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen502_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr503", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr503", ["_idrref", "_nodetref", "_noderref"], name: "_referen503_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr503", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen503_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr504", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr504", ["_idrref", "_nodetref", "_noderref"], name: "_referen504_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr504", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen504_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr505", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr505", ["_idrref", "_nodetref", "_noderref"], name: "_referen505_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr505", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen505_bynodemsg_rnr", unique: true, using: :btree

  create_table "_referencechngr511", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                 null: false
    t.binary  "_noderref",                 null: false
    t.decimal "_messageno", precision: 10
    t.binary  "_idrref",                   null: false
  end

  add_index "_referencechngr511", ["_idrref", "_nodetref", "_noderref"], name: "_referen511_bydatakey_rr", unique: true, using: :btree
  add_index "_referencechngr511", ["_nodetref", "_noderref", "_messageno", "_idrref"], name: "_referen511_bynodemsg_rnr", unique: true, using: :btree

  create_table "_seq1643", id: false, force: :cascade do |t|
    t.datetime "_period",       null: false
    t.binary   "_recordertref", null: false
    t.binary   "_recorderrref", null: false
  end

  add_index "_seq1643", ["_period", "_recordertref", "_recorderrref"], name: "_seq1643_bydims_tr", unique: true, using: :btree
  add_index "_seq1643", ["_recordertref", "_recorderrref"], name: "_seq1643_byrecorder_r", unique: true, using: :btree

  create_table "_seqb1644", id: false, force: :cascade do |t|
    t.datetime "_period",         null: false
    t.binary   "_recorder_type",  null: false
    t.binary   "_recorder_rtref", null: false
    t.binary   "_recorder_rrref", null: false
  end

  create_table "_seqchngr1645", id: false, force: :cascade do |t|
    t.binary  "_nodetref",                    null: false
    t.binary  "_noderref",                    null: false
    t.decimal "_messageno",    precision: 10
    t.binary  "_recordertref",                null: false
    t.binary  "_recorderrref",                null: false
  end

  add_index "_seqchngr1645", ["_nodetref", "_noderref", "_messageno", "_recordertref", "_recorderrref"], name: "_seqchn1645_bynodemsg_rnr", unique: true, using: :btree
  add_index "_seqchngr1645", ["_recordertref", "_recorderrref", "_nodetref", "_noderref"], name: "_seqchn1645_bydatakey_rr", unique: true, using: :btree

  create_table "_yearoffset", id: false, force: :cascade do |t|
    t.integer "ofset", null: false
  end

  create_table "dbschema", id: false, force: :cascade do |t|
    t.binary "serializeddata", null: false
  end

  create_table "ibversion", id: false, force: :cascade do |t|
    t.integer "ibversion",          null: false
    t.integer "platformversionreq", null: false
  end

end
