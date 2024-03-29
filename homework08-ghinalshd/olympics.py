import configparser
from operator import itemgetter

import sqlalchemy
from sqlalchemy import create_engine

# columns and their types, including fk relationships
from sqlalchemy import Column, Integer, Float, String, DateTime
from sqlalchemy import ForeignKey
from sqlalchemy.orm import relationship

# declarative base, session, and datetime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from datetime import datetime

# configuring your database connection
config = configparser.ConfigParser()
config.read('config.ini')
u, pw, host, db = itemgetter('username', 'password', 'host', 'database')(config['db'])
dsn = f'postgresql://{u}:{pw}@{host}/{db}'
print(f'using dsn: {dsn}')

# SQLAlchemy engine, base class and session setup
engine = create_engine(dsn, echo=True)
Base = declarative_base()
Session = sessionmaker(engine)
session = Session()

# TODO: Write classes and code here

class AthleteEvent(Base):
    __tablename__ = 'athlete_event'
    athlete_event_id = Column(Integer, primary_key=True, autoincrement=True)
    id = Column(Integer)
    name = Column(String)
    sex = Column(String)
    age = Column(Integer)
    height = Column(Integer)
    weight = Column(Integer)
    team = Column(String)
    noc = Column(String, ForeignKey('noc_region.noc'))
    games = Column(String)
    year = Column(Integer)
    season = Column(String)
    city = Column(String)
    sport = Column(String)
    event = Column(String)
    medal = Column(String)
    

    noc_region = relationship("NOCRegion", back_populates="athlete_events")

    def __repr__(self):
        return f"AthleteEvent(name='{self.name}', noc='{self.noc}', season='{self.season}', year='{self.year}', event='{self.event}', medal='{self.medal}')"

    def __str__(self):
        return f"{self.name}, {self.noc}, {self.season} {self.year} {self.event}, {self.medal}"

class NOCRegion(Base):
    __tablename__ = 'noc_region'
    noc = Column(String, primary_key=True)
    region = Column(String)
    note = Column(String)

    athlete_events = relationship("AthleteEvent", back_populates="noc_region")

    def __repr__(self):
        return f"NOCRegion(noc='{self.noc}', region='{self.region}')"

    def __str__(self):
        return f"{self.noc}, {self.region}"

# create the tables in the database
Base.metadata.create_all(engine)

# Insert a new record into the athlete_event table
event = AthleteEvent(
    name='Yuto Horigome',
    age=21,
    team='Japan',
    medal='Gold',
    year=2020,
    season='Summer',
    city='Tokyo',
    noc='JPN',
    event='Skateboarding, Street, Men'
)

session.add(event)
session.commit()

session.close()

print('\n\n\n')
# performing a search using above classes
result = session.query(AthleteEvent).\
    join(NOCRegion).\
    filter(AthleteEvent.noc == 'JPN', AthleteEvent.year >= 2016, AthleteEvent.medal == 'Gold')

for row in result:
    print('\n')
    print(f"Name: {row.name}, Region: {row.noc_region.region}, Event: {row.event}, Year: {row.year}, Season: {row.season}")