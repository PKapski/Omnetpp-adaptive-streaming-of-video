import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.node.inet.Router;
import inet.node.inet.StandardHost;
import inet.node.inet.WirelessHost;
import ned.DatarateChannel;
import inet.physicallayer.contract.packetlevel.IRadioMedium;

network ARPTest
{
    parameters:
        double C1_datarate @unit(bps) = default(100Mbps);
        double C1_delay @unit(s) = default(0.1us);
        double C1_per = default(0);
        double C1_ber = default(0);

        double C2_datarate @unit(bps) = default(4Mbps);
        double C2_delay @unit(s) = default(0.1us);
        double C2_per = default(0);
        double C2_ber = default(0);

        double download_datarate @unit(bps) = default(10Mbps);
        double download_delay @unit(s) = default(0.1us);
        double download_per = default(0);
        double download_ber = default(0);

        double upload_datarate @unit(bps) = default(2Mbps);
        double upload_delay @unit(s) = default(0.1us);
        double upload_per = default(0);
        double upload_ber = default(0);

    types:
        channel wiredLink extends DatarateChannel
        {
            datarate = C1_datarate;
            delay = C1_delay;
            per = C1_per;
            ber = C1_ber;
        }
        channel downloadExternalLink extends DatarateChannel
        {
            datarate = download_datarate;
            delay = download_delay;
            per = download_per;
            ber = download_ber;
            @display("ls=,,da");
        }
        channel uploadExternalLink extends DatarateChannel
        {
            datarate = upload_datarate;
            delay = upload_delay;
            per = upload_per;
            ber = upload_ber;
            @display("ls=black,,da");
        }
    submodules:
        router: Router {
            @display("p=334.96875,178.65");
        }
        host1: StandardHost {
            @display("p=576.14624,68.4825");
        }
        host2: StandardHost {
            @display("p=679,139");
        }
        host3: WirelessHost {
            @display("p=593,238");
        }
        host4: WirelessHost {
            @display("p=508,305");
        }
        server: StandardHost {
            parameters:
                @display("p=149,179;i=device/server");
        }
        radioMedium: <default("UnitDiskRadioMedium")> like IRadioMedium {
            @display("p=678,276");
        }
        configurator: Ipv4NetworkConfigurator {
            @display("p=44.6625,47.64");
        }
    connections:
        host1.pppg++ <--> wiredLink <--> router.pppg++;
        host2.pppg++ <--> wiredLink <--> router.pppg++;
        router.pppg$o++ --> downloadExternalLink --> server.pppg$i++;
        server.pppg$o++ --> uploadExternalLink --> router.pppg$i++;
}
