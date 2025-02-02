import Navbar from "./Navbar/Navbar";
import styles from "../styles/User.module.css";
import Image from "next/image";
import { Text } from "@nextui-org/react";

const User = () => {
  return (
    <>
      <Navbar />
      <div className={styles.main}>
        <h1 className={styles.heading}>USER GUIDELINES</h1>
      </div>

      <div className={styles.body}>
        <h2>
          How Paropakar works{" "}
          <big>
            <i>?</i>
          </big>
        </h2>
        There are three participants in this system. <b>Admin </b>,{" "}
        <b>Authorizers</b> and common <b>Users</b> (Like YOU).
        <br />
        Their functions are as follows:-
        <br />
        <br />
        <h3>1. ADMIN</h3>
        <div className={styles.paragraph}>
          <b>Admin</b> is the one who deployed the entire system. Admin assigns
          or revokes different accounts as authorizer. As it is a decentralized
          system, Admin cannot modify/delete the details donation or donation
          request. The identity of Admin is anonymous.
        </div>
        <br />
        <h3>2. AUTHORIZERS</h3>
        <div className={styles.paragraph}>
          <b>Authorizers</b> are the accounts assigned by the Admin whose main
          task is to verify donation request. Only after verification of
          donation request by authorizer, it will be displayed to user for
          donation.
          <br />
          The identity of Authorizers are anonymous.
        </div>
        <br />
        <h3>3. USERS</h3>
        <div className={styles.paragraph}>
          <b>User</b> are the one who use this system to either ask for donation
          or request donation from other users.
        </div>
        <br />
        <h2>
          How to use it{" "}
          <big>
            <i>?</i>
          </big>
        </h2>
        <h3> 1. DONATION REQUEST</h3>
        <div className={styles.paragraph}>
          <Image
            src={"/registration.png"}
            height={700}
            width={1300}
            quality={100}
            className={styles.image}
            alt="image"
          ></Image>
          <br />
          Donation request can be made by filling a form from <b>Create</b>{" "}
          option in Navbar. All the information must be filled.
        </div>
        <u>
          After your campaign registration, you can check Registered campaign at{" "}
          <i>Application status</i>
        </u>{" "}
        from Navbar portal.
        <br />
        <br />
        <Image
          src={"/check.png"}
          height={700}
          width={1300}
          quality={100}
          className={styles.image}
          alt="image"
        ></Image>
        <br />
        <br />
        <hr className={styles.line}></hr>
        <br />
        <h3>
          <b>2.</b> APPLICATION STATUS
        </h3>
        <Image
          src={"/applicationStatus.png"}
          height={700}
          width={1300}
          quality={100}
          className={styles.image}
          alt="image"
        ></Image>
        <br />
        <br />
        <u>
          <b>Pending Request</b>
        </u>{" "}
        Table displays all the application that you have registered that which
        will be checked (and if everything is good) by the Authorizer.
        <br />
        <u>
          <b>Your Campaign </b>
        </u>{" "}
        Table displays all the application that that are verified by Authorizer.
        <br />
        <br />
        <hr className={styles.line}></hr>
        <br />
        <h3>3. CAMPAIGN PAGE</h3>
        Campaign page is accessible by clicking <big>Campaign</big> option in
        Navabar.
        <br />
        <Image
          src={"/campaignPage.png"}
          height={700}
          width={1300}
          quality={100}
          className={styles.image}
          alt="image"
        ></Image>
        <br />
        In this page a number of verified campaigns are displayed. Campaigns can
        also searchable according to the categories from the search bar.
        <br />
        <br />
        <hr className={styles.line}></hr>
        <br />
        <h3>4. CAMPAIGN DETAILS</h3>
        This page is seen after you clicked on one of the donation campaign in
        Campaign Page.
        <br />
        It shows different details related to the campaign like :-{" "}
        <i>Authorizer address, Owner address, Target, Deadline, etc.</i>
        <br />
        <br />
        {/* <hr className={styles.line}></hr> */}
        <b>4.1</b> How To Donate{" "}
        <b>
          <i>?</i>
        </b>
        <br />
        <br />
        <div className={styles.donate}>
          <Image
            src={"/howToDonate.png"}
            height={500}
            width={500}
            quality={100}
            className={styles.image}
            alt="image"
          ></Image>

          <div className={styles.sideInfo}>
            All the necessary information related to the campaign are present in
            Campaign Details card.
            <br />
            By clicking in <Text style={{ color: "blue" }}> View Protocol</Text>
            , you can view pdf file related to donation request.
            <br />
            You can donate by filling{" "}
            <font
              style={{
                border: "1px solid grey",
                color: "grey",
                padding: "5px",
              }}
            >
              Amount
            </font>{" "}
            in input bar and clicking donate.
            <br />
            Once you click donate, your cryptoWallet account will pop up and ask
            to confirm the transaction.
            <br />
            After you click 'CONFIRM'. Transaction process takes place and if
            successfull details is shown. Details could alse be tracked in{" "}
            <a href="https://mumbai.polygonscan.com/" target="_blank">
              POLYGONSCAN
            </a>
          </div>
        </div>
        <br />
        <b>4.1</b> How to View Donation Details{" "}
        <b>
          <i>?</i>
        </b>
        <br />
        <br />
        To view number of donors to a particular campaign (as well as your
        details), click{" "}
        <Text
          style={{
            padding: "5px",
            color: "blue",
            border: "1px solid blue",
            borderRadius: "10px",
          }}
        >
          {" "}
          Campaign Donation Log
        </Text>
        <br />
        You'll see a Table with information such as: Donor Address, Amount,
        Time. It also contains search bar where search is done according to
        address.
        <br />
        <Image
          src={"/campaignDonationLog.png"}
          height={700}
          width={1300}
          quality={100}
          className={styles.image}
          alt="image"
        ></Image>
        <br />
        <br />
        <hr className={styles.line}></hr>
        <br />
        <h3>
          5. HOW TO ATTAIN REQUESTED FUND <i>?</i>
        </h3>
        <Image
          src={"/campaignRequestLog.png"}
          height={700}
          width={1300}
          quality={100}
          className={styles.image}
          alt="image"
        ></Image>
        <br />
        <br />
        As a Donor to attain donation from donor, click{" "}
        <Text
          style={{
            padding: "5px",
            color: "blue",
            border: "1px solid blue",
            borderRadius: "10px",
          }}
        >
          Donation Request Log
        </Text>
        <br />
        As shown in picture, a form and a table will be seen in the same page at
        the bottom.
        <br />
        Activity Log table displays information about donation received to a
        particular contract along with date.
        <br />
        Fill up the form and{" "}
        <Text
          style={{
            padding: "5px",
            color: "white",
            background: "blue",
            border: "1px solid none",
            borderRadius: "10px",
          }}
        >
          CREATE REQUEST
        </Text>
        <br />
        <br />
      </div>
    </>
  );
};

export default User;
