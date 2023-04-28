//
//  TermsAndConditonsView.swift
//  Geothermal
//
//  Created by Yuntian Wan on 21/4/2023.
//

import SwiftUI

struct TermsAndConditionsView: View {
    var body: some View {
        ScrollView {
            // TODO: Make this page look better.
            Text("""
            These Additional Terms are between you and the University of Melbourne (University), and govern your use of the "Geothermal application" (App). These Additional Terms are in addition to and supplement the Apple terms (Third Party Terms) applicable to your use of the App. In the event of any inconsistency between these Additional Terms and the Third Party Terms, these Additional Terms will prevail to the extent of any inconsistency.
            By using the App, you are deemed to have read and understood, and agree to be bound by and abide by, these Additional Terms (as amended by the University from time to time).
            1.    Use of the App
            1.1    Acknowledgement and agreement
            The App is a tool which provides some pre-design calculations for geothermal ground-source heat pump (GSHP) systems. You acknowledge and agree that the University gives no representations as to the operation of the App or the accuracy of any outputs from the App and that the App should used as a guide only, and not as a source upon which any decisions are made.  Before using any information obtained through the App you should:
            (a)    independently verify the accuracy, currency or completeness of any that information; and
            (b)    seek independent advice from an appropriately qualified professional.
            The University is not liable to you or anyone else for any decision made or action taken in reliance upon any information obtained through the App.
            1.2    Suspension and cancellation
            The University may suspend or cancel your access to or use of the App, at any time without prior notice. You may cease to use the App by removing the application from your device and deleting any relevant software from your device or computer.
            1.3    Privacy
            (a)    The University may collect, store and provide to third party service providers 'personal information' and 'sensitive information' as defined in the Information Privacy Act 2000 (Vic).
            (b)    The University's privacy policy relating to information collected by the University may be accessed at http://policy.unimelb.edu.au/MPF1104 and forms part of these Additional Terms.
            2.    Warranties and indemnity
            2.1    Consumer guarantees
            (a)    In addition to any rights you may have under these Additional Terms, you may also have other rights under statutes which vary from jurisdiction to jurisdiction. In particular, you may have rights under consumer guarantees which apply to the supply of products or services under the Australian Consumer Law (as set out in Schedule 2 to the Competition and Consumer Act 2010 (Cth)), as amended from time to time, or other similar legislation of a state or territory of Australia regarding goods or services, which cannot be excluded, restricted or modified by these Additional Terms (collectively, Consumer Guarantees).
            (b)    These Additional Terms do not exclude, restrict or modify the application of the Consumer Guarantees or any other any condition, warranty, guarantee, right or remedy conferred by or implied under any provision of any statute where to do so would:
            (i)    contravene the relevant statute; or
            (ii)    cause any part of these Additional Terms to be void and/or unenforceable.
            2.2    Limitation of liability
            (a)    In clauses 2.2 and 2.3, Losses means all liabilities, losses, damages, costs and expenses including:
            (i)    direct, indirect or consequential liabilities, losses, damages, costs and expenses;
            (ii)    legal costs and disbursements, whether incurred or awarded against a party, including costs of investigation, litigation, settlement and compliance with judgments; and
            (iii)    interest, fines and penalties,
            suffered or incurred by any person, and whether arising in contract, tort (including negligence) or otherwise.
            (b)    Other than the Consumer Guarantees, the University excludes all warranties, conditions or other terms, whether implied by statute or otherwise including, without limitation, all representations or warranties, either express or implied, about content contained on the App or services provided to you through the App for any purpose (including representations about the accuracy, currency, completeness or suitability of the information published on the App).
            (c)    Except for liability under the Consumer Guarantees, the University excludes liability for all Losses suffered or incurred by any person:
            (i)    in connection with or in any way relating to the App, including any disruption to the App or interference with or damage to computer systems or other electronic devices; or
            (ii)    in connection with any errors, omissions or inaccuracies contained in any information published on the App, including Losses in connection with your reliance on information obtained through the App; and
            (iii)    otherwise under or in connection with these Additional Terms.
            (d)    Except for liability under the Consumer Guarantees, to the extent that the University is unable to exclude its liability under this clause 2.2,  The University limits its liability, at The University' option and to the maximum extent permitted by law, to:
            (i)    resupplying the services or equivalent services; or
            (ii)    paying the cost of having the services or equivalent services resupplied.


            2.3    Indemnity
            (a)    You indemnify the University and each of its directors, officers, employees, agents, advisers, consultants and contractors (collectively, Indemnified Persons) against all Losses arising from or relating to:
            (i)    your use of the App;
            (ii)    your breach of these Additional Terms or breach of law;
            (iii)    your breach of any Third Party Terms; or
            (iv)    any claim alleging that you have infringed the intellectual property or other rights of any person.
            (b)    If any Indemnified Person suffers or incurs any Loss as a result of your breach of these Additional Terms or other act or omission and the University would have been able to recover those Losses if the Losses were suffered or incurred by the University, then the University will be able to recover those Losses as if those Losses were suffered or incurred by the University.
            3.    General
            3.1    Changes to Additional Terms
            The University may change these Additional Terms at any time. You agree to be bound by the changed terms if you continue to use the App after the terms have changed.
            3.2    Severability
            If any part of these Additional Terms is held to be invalid, illegal, or unenforceable, that part will be severed and the remaining parts of these Additional Terms will continue in force.
            3.3    Governing law
            These terms are governed by the laws applicable in the State of Victoria, Australia and you submit to the non-exclusive jurisdiction of the courts of that State.



            """)
            .padding()
        }
        .navigationBarTitle(Text("Terms and Conditions"), displayMode: .inline)
    }
}

struct TermsAndConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndConditionsView()
    }
}
