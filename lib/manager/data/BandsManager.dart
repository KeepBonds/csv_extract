import '../manager.dart';
import '../../object/object.dart';

class BandsManager {
  static List<Bands> bands = [
      Bands(band: "B1", frequency: "10MHz", otherData: "2110 – 2170MHz", specAntenna1: -95, specAntenna2: -95.5, specAntenna3: -94.5, specAntenna4: -94.5),
      Bands(band: "B2", frequency: "10MHz", otherData: "1930 – 1990MHz", specAntenna1: -95, specAntenna2: -94, specAntenna3: -90, specAntenna4: -90),
      Bands(band: "B3", frequency: "10MHz", otherData: "1805 – 1880MHz", specAntenna1: -94.5, specAntenna2: -96, specAntenna3: -94, specAntenna4: -93),
      Bands(band: "B4", frequency: "10MHz", otherData: "2110 – 2155MHz", specAntenna1: -95, specAntenna2: -96, specAntenna3: -95, specAntenna4: -94),
      Bands(band: "B5", frequency: "10MHz", otherData: "869 – 894MHz", specAntenna1: -95.5, specAntenna2: -94),
      Bands(band: "B7", frequency: "10MHz", otherData: "2620 – 2690MHz", specAntenna1: -95, specAntenna2: -96.5, specAntenna3: -95, specAntenna4: -94),
      Bands(band: "B8", frequency: "10MHz", otherData: "925 – 960MHz", specAntenna1: -92.5, specAntenna2: -95),
      Bands(band: "B12", frequency: "10MHz", otherData: "729 – 746MHz", specAntenna1: -93.5, specAntenna2: -93.5),
      Bands(band: "B13", frequency: "10MHz", otherData: "746 – 756MHz", specAntenna1: -94, specAntenna2: -96),
      Bands(band: "B14", frequency: "10MHz", otherData: "758 – 768MHz", specAntenna1: -92, specAntenna2: -90),
      Bands(band: "B17", frequency: "10MHz", otherData: "734 – 746MHz", specAntenna1: -93.5, specAntenna2: -93.5),
      Bands(band: "B18", frequency: "10MHz", otherData: "860 – 875MHz", specAntenna1: -95, specAntenna2: -96),
      Bands(band: "B19", frequency: "10MHz", otherData: "875 – 890MHz", specAntenna1: -93.5, specAntenna2: -93),
      Bands(band: "B20", frequency: "10MHz", otherData: "791 – 821MHz", specAntenna1: -94, specAntenna2: -95),
      Bands(band: "B25", frequency: "10MHz", otherData: "1930 – 1995MHz", specAntenna1: -95.5, specAntenna2: -94, specAntenna3: -90, specAntenna4: -90),
      Bands(band: "B26", frequency: "10MHz", otherData: "859 – 894MHz", specAntenna1: -94, specAntenna2: -92),
      Bands(band: "B28", frequency: "10MHz", otherData: "758 – 803MHz", specAntenna1: -93.5, specAntenna2: -94.5),
      Bands(band: "B29", frequency: "10MHz", otherData: "717 – 728MHz", specAntenna1: -93, specAntenna2: -91.5),
      Bands(band: "B30", frequency: "10MHz", otherData: "2350 – 2360MHz", specAntenna1: -94, specAntenna2: -93.5, specAntenna3: -92, specAntenna4: -92),
      Bands(band: "B38", frequency: "10MHz", otherData: "2570 – 2620MHz", specAntenna1: -95, specAntenna2: -96.5, specAntenna3: -94, specAntenna4: -94),
      Bands(band: "B39", frequency: "10MHz", otherData: "1880 – 1920MHz", specAntenna1: -92, specAntenna2: -92, specAntenna3: -90, specAntenna4: -90),
      Bands(band: "B40", frequency: "10MHz", otherData: "2300 – 2400MHz", specAntenna1: -92, specAntenna2: -92, specAntenna3: -90, specAntenna4: -90),
      Bands(band: "B41", frequency: "10MHz", otherData: "2496 – 2690MHz", specAntenna1: -96, specAntenna2: -95, specAntenna3: -94, specAntenna4: -94),
      Bands(band: "B42", frequency: "10MHz", otherData: "3400 – 3600MHz", specAntenna1: -92, specAntenna2: -92, specAntenna3: -90, specAntenna4: -90),
      Bands(band: "B43", frequency: "10MHz", otherData: "3600 – 3800MHz", specAntenna1: -92, specAntenna2: -92, specAntenna3: -90, specAntenna4: -90),
      Bands(band: "B46", frequency: "10MHz", otherData: "5150 – 5925MHz", specAntenna1: -92, specAntenna2: -92),
      Bands(band: "B48", frequency: "10MHz", otherData: "3550 – 3700MHz", specAntenna1: -95, specAntenna2: -96, specAntenna3: -90, specAntenna4: -90),
      Bands(band: "B66", frequency: "10MHz", otherData: "2110 – 2200MHz", specAntenna1: -95, specAntenna2: -96.5, specAntenna3: -94, specAntenna4: -94),
      Bands(band: "B71", frequency: "10MHz", otherData: "617 – 652MHz", specAntenna1: -94.5, specAntenna2: -94),
      Bands(band: "N1", frequency: "10MHz", otherData: "2110 – 2170MHz", specAntenna1: -95, specAntenna2: -95.5, specAntenna3: -94.5, specAntenna4: -94.5),
      Bands(band: "N2", frequency: "10MHz", otherData: "1930 – 1990MHz", specAntenna1: -95, specAntenna2: -94, specAntenna3: -90, specAntenna4: -90),
      Bands(band: "N3", frequency: "10MHz", otherData: "1805 – 1880MHz", specAntenna1: -94.5, specAntenna2: -96, specAntenna3: -94, specAntenna4: -93),
      Bands(band: "N4", frequency: "10MHz", otherData: "2110 – 2155MHz", specAntenna1: -95, specAntenna2: -96, specAntenna3: -95, specAntenna4: -94),
      Bands(band: "N5", frequency: "10MHz", otherData: "869 – 894MHz", specAntenna1: -95.5, specAntenna2: -94),
      Bands(band: "N7", frequency: "10MHz", otherData: "2620 – 2690MHz", specAntenna1: -95, specAntenna2: -96.5, specAntenna3: -95, specAntenna4: -94),
      Bands(band: "N12", frequency: "10MHz", otherData: " 729 – 746MHz", specAntenna1: -93.5, specAntenna2: -93),
      Bands(band: "N20", frequency: "10MHz", otherData: " 791 – 821MHz", specAntenna1: -94, specAntenna2: -95),
      Bands(band: "N25", frequency: "10MHz", otherData: " 1930 – 1995MHz", specAntenna1: -95.5, specAntenna2: -94, specAntenna3: -90, specAntenna4: -90),
      Bands(band: "N28", frequency: "10MHz", otherData: " 758 – 803MHz", specAntenna1: -93.5, specAntenna2: -94.5),
      Bands(band: "N38", frequency: "10MHz", otherData: " 2570 – 2620MHz", specAntenna1: -95, specAntenna2: -96.5, specAntenna3: -94, specAntenna4: -94),
      Bands(band: "N41", frequency: "10MHz", otherData: " 2496 – 2690MHz", specAntenna1: -96, specAntenna2: -95, specAntenna3: -94, specAntenna4: -94),
      Bands(band: "N48", frequency: "10MHz", otherData: " 3550 – 3700MHz", specAntenna1: -95, specAntenna2: -96, specAntenna3: -90, specAntenna4: -90),
      Bands(band: "N66", frequency: "10MHz", otherData: " 2110 – 2200MHz", specAntenna1: -95, specAntenna2: -96.5, specAntenna3: -94, specAntenna4: -94),
      Bands(band: "N71", frequency: "10MHz", otherData: " 617 – 652MHz", specAntenna1: -94.5, specAntenna2: -94),
      Bands(band: "N77", frequency: "10MHz", otherData: " 3300 – 4200MHz", specAntenna1: -95, specAntenna2: -95, specAntenna3: -95, specAntenna4: -95),
      Bands(band: "N78", frequency: "10MHz", otherData: " 3300 – 3800MHz", specAntenna1: -93, specAntenna2: -93, specAntenna3: -93, specAntenna4: -91),
      Bands(band: "N79", frequency: "10MHz", otherData: " 4400 – 5000MHz", specAntenna1: -94, specAntenna2: -94, specAntenna3: -93, specAntenna4: -92),
  ];

  static Bands? getBandFromFileData(FileData data) {
      Iterable<Bands> bandsIte = bands.where((element) => element.band.toLowerCase() == data.band.toLowerCase());
      if(bandsIte.isEmpty) {
          return null;
      }
      return bandsIte.first;
  }

  static BandsAverage? processBand(FileData data) {
      Bands? band = getBandFromFileData(data);
      if(band == null) {
          return null;
      }
      List<AntennaAverage> averagePerAntenna = FileDataManager.getMeanPerAntenna(data);
      List<AntennaData> datasPerAntenna = FileDataManager.getAntennaDatas(data);

      return BandsAverage(bands: band, antennaAverage: averagePerAntenna, antennaDatas: datasPerAntenna, fileFrequency: data.nameFrequency, directoryName: data.parentDirectory);
  }
}